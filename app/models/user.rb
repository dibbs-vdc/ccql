class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  #validates :first_name, presence: true
  #validates :last_name, presence: true
  #validates :email, presence: true
  #validates :organization, presence: true
  #validates :position, presence: true
  #validates :discipline, presence: true
  #validates :orcid, presence: true
  #validates :email, presence: true

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :cv_file, CvFileUploader
  validates_integrity_of :cv_file # Checks for type whitelist
  validates_processing_of :cv_file

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

  validate :validate_organization
  def validate_organization
    #TODO: Should I make 'other' a constant?
    if (organization == 'other') and (organization_other.strip == '')
      errors.add(:organization_other, 'You must provide a description of your organization if "Other" is selected.')
    end
  end

  #TODO: Should this be in a controller instead?
  after_create :send_admin_mail_after_registration
  def send_admin_mail_after_registration
    AdminMailer.new_user_waiting_for_approval(self).deliver
    AdminMailer.new_user_waiting_for_approval_admin_notification(self).deliver
  end

    def password_required?
      if !persisted?
        false
      else
        !password.nil? || !password_confirmation.nil?
      end
    end

end
