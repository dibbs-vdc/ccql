class AdminMailer < ApplicationMailer
  default from: Rails.configuration.admin_mailer['default_from']
 
  def new_user_waiting_for_approval(user)
    @user = user
    to_email = @user.email
    subject = Rails.configuration.admin_mailer['new_user_waiting_for_approval_subject']
    mail(to: to_email, subject: subject)
  end

  def new_user_waiting_for_approval_admin_notification(user)
    @user = user
    admin_email = Rails.configuration.admin_mailer['admin_email']
    subject_template = Rails.configuration.admin_mailer['new_user_waiting_for_approval_admin_notification_subject']
    subject = subject_template % { user_email: @user.email }
    mail(to: admin_email, subject: subject)
  end

  def new_user_approval(user)
    @user = user
    @login_url = Rails.configuration.admin_mailer['login_url']
    subject = Rails.configuration.admin_mailer['new_user_approval_subject']
    mail(to: @user.email, subject: subject)
  end
  
  def updated_person_admin_notification(user)
    @user = user
    admin_email = Rails.configuration.admin_mailer['admin_email']
    subject_template = Rails.configuration.admin_mailer['updated_person_admin_notification_subject']
    subject = subject_template % { user_email: @user.email }
    mail(to: admin_email, subject: subject)
  end
end
