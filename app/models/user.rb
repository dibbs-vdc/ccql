class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats



  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  #mount_uploader :cv_file, CvFileUploader

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    "#{last_name}, #{first_name}"
  end

  # Method to help with admin user registration approval
  def active_for_authentication? 
    super && approved? 
  end 
  
  # MEthod to help with  admin user registration approval
  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end

  after_create :send_admin_mail_after_registration
  def send_admin_mail_after_registration
    AdminMailer.new_user_waiting_for_approval(self).deliver
    AdminMailer.new_user_waiting_for_approval_admin_notification(self).deliver
  end
end
