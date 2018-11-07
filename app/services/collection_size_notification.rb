class CollectionSizeNotification
  THRESHOLD = ['1_tb', '1_tb_plus'].freeze

  ##
  # @!attribute [rw] collection
  #   @return [Collection]
  # @!attribute [rw] mailer
  #   @return [ApplicationMailer]
  attr_accessor :collection, :mailer

  ##
  # @param [Collection]
  def initialize(collection:, mailer: CollectionMetadataMailer)
    self.collection = collection
    self.mailer     = mailer
  end

  ##
  # @return [void]
  def notify
    return :no_op unless THRESHOLD.include?(collection.collection_size)

    mailer
      .with(collection: collection)
      .size_message
      .deliver_now
  end
end
