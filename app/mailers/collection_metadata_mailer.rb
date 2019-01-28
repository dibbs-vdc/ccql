# frozen_string_literal: true

##
# Mailer for notifications about collection metadata changes
#
# When Collections are changed to include certian metadata (e.g. size > 100 GB)
# we want to notify administrators. This mailer handles sending those
# notifications.
#
class CollectionMetadataMailer < ApplicationMailer
  default from: Rails.configuration.admin_mailer['default_from'],
          to:   Rails.configuration.admin_mailer['admin_email']

  def size_message
    @collection    = params[:collection]
    @vocab_service = CollectionSizeService.new

    mail(subject: t('hyrax.collection_mailer.size_message.subject'))
  end
end
