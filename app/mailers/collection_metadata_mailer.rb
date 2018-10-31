# frozen_string_literal: true

##
# Mailer for notifications about collection metadata changes
#
# When Collections are changed to include certian metadata (e.g. size > 100 GB)
# we want to notify administrators. This mailer handles sending those
# notifications.
#
class CollectionMetadataMailer < ApplicationMailer
  def size_message
    @user          = params[:user]
    @collection    = params[:collection]
    @vocab_service = CollectionSizeService.new

    mail(to:      @user.email,
         subject: t('hyrax.collection_mailer.size_message.subject'))
  end
end
