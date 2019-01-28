# frozen_string_literal: true
module Vdc
  ##
  # Finds usage data for individual resources.
  #
  # Given a `Vdc::Resource` this can tell us:
  #
  #   - a total usage `#count`
  #   - a list of unique `#purposes`
  #   - a list of `Vdc::Usage` objects (as an `ActiveRecord::Relation`)
  #
  # @example using class query syntax
  #   ResourceUsage.usages_for(resource: my_resource)
  #
  # @example getting data from an instance
  #   usage = ResourceUsage.new(resource: my_resource)
  #   usage.count    # => 2
  #   usage.purposes # => ["description of reason for use"]
  #   usage.usages   # => ActiveRecord::Relation<Vdc::Usage>
  #
  class ResourceUsage
    ##
    # @!attribute [rw] resource_gid
    #   @return [GlobalID]
    attr_accessor :resource_gid

    ##
    # @param resource [#to_global_id]
    #
    # @return [Enumerable<Vdc::Usage>]
    # @raise [URI::GID::MissingModelIdError]
    def self.usages_for(resource:)
      new(resource: resource).usages
    end

    ##
    # @param resource [#to_global_id]
    #
    # @raise [URI::GID::MissingModelIdError]
    def initialize(resource:)
      self.resource_gid = resource.to_global_id
    end

    ##
    # @return [Integer]
    def count
      usages.count
    end

    ##
    # @return [Enumerable<#to_s>]
    def purposes
      usages.pluck(:purpose).uniq
    end

    ##
    # @return [Enumerable<Vdc::Usage>]
    def usages
      Vdc::Usage.where(work_gid: resource_gid.to_s)
    end
  end
end
