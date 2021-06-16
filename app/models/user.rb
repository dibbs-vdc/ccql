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

  serialize :discipline

  scope :registered, ->() { where(guest: false).where(approved: true) }
  scope :not_approved, ->() {  where(guest: false).where(approved: false) }

  def display_name
    return to_s if last_name.blank? || first_name.blank?
    "#{last_name}, #{first_name}"
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  # TODO: Need to eventually change the depositor email used in solr searches.
  #       Should switch to using the uuid or something else that can't potentially
  # change in the future.
  def to_s
    email
  end

  # Method to help with admin user registration approval
  def active_for_authentication?
    super && approved?
  end

  # Method to help with  admin user registration approval
  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def self.from_omniauth(auth)
    Rails.logger.error("omniauth: #{auth}")
    find_by(email: auth.info.email)
  end

  validate :validate_organization
  def validate_organization
    #TODO: Should I make 'other' a constant somewhere?
    if (organization == 'other') and (organization_other.strip == '')
      errors.add(:organization_other, 'You must provide a description of your organization if "Other" is selected.')
    end
  end

  after_validation :check_url_protocols
  def check_url_protocols
    # TODO: There's gotta be a more efficient way to do this...

    self.website = add_url_protocol(self.website)
    self.cv_link = add_url_protocol(self.cv_link)
    self.sites_open_science_framework_url = add_url_protocol(self.sites_open_science_framework_url)
    self.sites_researchgate_url = add_url_protocol(self.sites_researchgate_url)
    self.sites_linkedin_url = add_url_protocol(self.sites_linkedin_url)
    self.sites_vivo_url = add_url_protocol(self.sites_vivo_url)
    self.sites_institutional_repo_url = add_url_protocol(self.sites_institutional_repo_url)
    self.sites_other_url = add_url_protocol(self.sites_other_url)
  end

  def add_url_protocol(url)
    return url if !url || url.blank?
    return url if url[/\Ahttp/]
    return "http://#{url}"
  end

  #TODO: Should this be in a controller instead?
  after_create :send_admin_mail_after_registration
  def send_admin_mail_after_registration
    if !self.guest
      AdminMailer.new_user_waiting_for_approval(self).deliver
      AdminMailer.new_user_waiting_for_approval_admin_notification(self).deliver
    end
  end

  def guest=(value)
    if !value
      AdminMailer.new_user_waiting_for_approval(self).deliver
      AdminMailer.new_user_waiting_for_approval_admin_notification(self).deliver
    end
    super(value)
  end

  def password_required?
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def recent_users(start_date, end_date = nil)
    end_date ||= DateTime.current # doing or eq here so that if the user passes nil we still get now
    User.where(created_at: start_date..end_date).where(approved: true)
  end

  # NOTE: discipline is set via a multi-select form input field.
  #       These multi-selects always send a hidden blank field
  #       which muddles things when trying to save and display values.
  #       I'm not sure how to get around this, but for now, I'm
  #       putting in code to remove blank fields before validation
  #
  #       https://stackoverflow.com/questions/8929230/why-is-the-first-element-always-blank-in-my-rails-multi-select-using-an-embedde
  #before_validation do |user|
    #byebug
    #self.discipline = self.discipline.reject(&:blank?) if self.discipline #NG
    #user.discipline.reject!(&:blank?) if user.discipline #NG
  #end

end
