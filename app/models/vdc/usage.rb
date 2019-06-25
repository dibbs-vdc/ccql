##
# Model for dataset usage information.
#
# @example
#   Vdc::Usage.create(work: Vdc::Resource.find(uuid),
#                     user: User.find(1),
#                     purpose: 'Data will be used unchaged.')
#
module Vdc
  class Usage < ApplicationRecord
    belongs_to :user
    attr_accessor :href

    validates :work_gid, format: { with: /\Agid\:\/\// }

    ##
    # @return [#to_global_id] the object referenced by `#work_gid`
    #
    # @raise [ActiveFedora::ObjectNotFoundError] when `#work_gid` doesn't
    #   identify any object
    def work
      return nil unless work_gid.present?

      GlobalID::Locator.locate(work_gid)
    end

    ##
    # @param [#to_global_id]
    #
    # @return [void]
    #
    # @raise [URI::GID::MissingModelIdError]
    def work=(work)
      self.work_gid = work.to_global_id
    end

    def work_id=(id)
      self.work_gid = Vdc::Resource.find(id)&.to_global_id
    end

    def work_id
      if self.work_gid
        Vdc::Resource.find(self.work_gid)
      end
    end
  end
end
