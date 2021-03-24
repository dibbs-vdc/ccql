#
# Encapsulates a Globus export request.
#
# The public API consists principally of the class methods.
# For the most part, you should be able to use
# `Globus::Export.call(dataset_id)'.
# If you want to instantiate the export but not run it, you can use `new`
#
# Adapted from work at Duke University:
# https://gitlab.oit.duke.edu/ddr/rdr/-/blob/develop/app/models/globus/export.rb
#
class Globus::Export < ApplicationRecord
  attr_reader :dataset
  serialize :expected_file_sets, Array
  serialize :completed_file_sets, Array
  validates_uniqueness_of :dataset_id

  after_initialize :initialize_workflow

  self.table_name = 'globus_exports'

  WORKFLOW_STATE_NEW = 'new'
  WORKFLOW_STATE_COMPLETE = 'exported'
  WORKFLOW_STATE_ERROR = 'error'

  # Main public API entrypoint
  #
  # @param dataset_or_id [Dataset, String] the Dataset to export
  # @return [Globus::Export] the export
  def self.call(dataset_or_id)
    dataset_id = dataset_or_id.try(:id) || dataset_or_id
    find_or_create_by!(dataset_id: dataset_id).tap do |export|
      export.workflow_state = WORKFLOW_STATE_NEW
      export.run
    end
  end

  # Is the given dataset ready for download by Globus? In other words, have all of
  # its filesets been attached and exported?
  # @param dataset_id [String] the id of the Dataset to check
  def self.ready_for_globus?(dataset_id)
     ge = Globus::Export.find_by(dataset_id: dataset_id)
     return true if ge && ge.ready_for_globus?
     false
  end

  # Export all datasets via background jobs
  def self.export_all
    Vdc::Resource.find_each do |resource|
      # Only export public data sets
      next unless resource.visibility == 'open'
      ::Globus::ExportJob.perform_later(resource.id)
    end
  end

  def self.file_set_added(file_set)
    file_set.member_of.each do |concern|
      ge = Globus::Export.find_or_create_by(dataset_id: concern.id)
      return true if ge.expected_file_sets.include?(file_set.id)
      ge.expected_file_sets << file_set.id
      ge.save!
    end
  end

  ##
  # When a new object is created, set its workflow state to new
  def initialize_workflow
    self.workflow_state ||= WORKFLOW_STATE_NEW
  end

  def ready_for_globus?
    return true if self.expected_file_sets.uniq.sort == self.completed_file_sets.uniq.sort
    false
  end

  ##
  # The directory to which exported files will be written.
  # Raise an error if GLOBUS_EXPORT_PATH is not defined.
  # @return [String]
  def export_path
    return ENV['GLOBUS_EXPORT_PATH'] if ENV['GLOBUS_EXPORT_PATH']
    raise "GLOBUS_EXPORT_PATH is not defined"
  end

  # Is it ready to retrieve from Globus?
  def exported?
    return true if self.workflow_state == WORKFLOW_STATE_COMPLETE
    false
  end

  def new?
    return true if self.workflow_state == WORKFLOW_STATE_NEW
    false
  end

  def error?
    return true if self.workflow_state == WORKFLOW_STATE_ERROR
    false
  end

  ##
  # Actually perform the export: For each fileset attached to this object,
  # check whether it is public. If it is, make a directory under the unique id
  # for the object and write the file there.
  def run
    @dataset = ActiveFedora::Base.find(dataset_id)
    return unless dataset.file_sets.count > 0
    export_dir = File.join(export_path, dataset.id)
    FileUtils.mkdir_p export_dir
    dataset.file_sets.each do |fs|
      next if fs.files.empty?
      file = fs.original_file
      export_file = File.join(export_dir, file.original_name).to_s
      File.open(export_file, 'wb') do |f|
        file.stream.each { |chunk| f.write(chunk) }
      end
    end
    Rails.logger.info "#{dataset.id} successfully exported for Globus"
    self.workflow_state = WORKFLOW_STATE_COMPLETE
    self.save
  rescue => e
    Rails.logger.error "Error in export for #{dataset.id}: #{e}"
    self.workflow_state = WORKFLOW_STATE_ERROR
    self.save
    raise e
  end

  def url
    if self.workflow_state == WORKFLOW_STATE_COMPLETE
      u = URI(self.class.globus_base_url)
      u.query = URI.encode_www_form(origin_id: self.class.globus_export_origin_id, origin_path: "/#{dataset_id}/")
      u.to_s
    end
  end

  # The base url of the globus file manager
  def self.globus_base_url
    ENV['GLOBUS_BASE_URL'] || "https://app.globus.org/file-manager"
  end

  # The UUID of the Globus "collection" used for export
  def self.globus_export_origin_id
    return ENV['GLOBUS_EXPORT_ORIGIN_ID'] if ENV['GLOBUS_EXPORT_ORIGIN_ID']
    raise "GLOBUS_EXPORT_ORIGIN_ID is not defined"
  end

  # @param dataset_id [String] Dataset ID
  # @return [String] Globus URL to dataset
  # @example
  #   https://app.globus.org/file-manager?origin_id=b69b1552-13c8-11eb-81b3-0e2f230cc907&origin_path=%2F7s75dd04w%2F
  def self.url_for(dataset_id)
    ge = Globus::Export.find_by(dataset_id: dataset_id)
    ge.url if ge
  end


end
