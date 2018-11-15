class AddRegistrationFieldsToUser < ActiveRecord::Migration[5.0]
  def change

    # How did you learn about us?
    add_column :users, :vdc_referral_method, :string
    add_column :users, :vdc_referral_method_other, :string

    add_column :users, :first_name,  :string, null: false, default: ''
    add_column :users, :last_name,  :string, null: false, default: ''

    # Organization or Institution (e.g., Rutgers University)
    add_column :users, :organization,  :string, null: false, default: ''
    add_column :users, :organization_other,  :string

    # Department (already exists in User)

    # Position in the VDC (e.g., Professor, Postdoctoral Position, Other, etc.)
    add_column :users, :position,  :string, null: false, default: ''
    add_column :users, :position_other,  :string

    # Discipline (Can be more than one, e.g., ['Agriculture','Biology'])
    add_column :users, :discipline, :text, array: true
    add_column :users, :discipline_other,  :string

    # Orcid (already exists in User)

    add_column :users, :edu_person_principal_name,  :string, null: false, default: ''

    # Address (already exists in User)
    # Email (already exists in User)

    # CV link or uploaded file
    # TODO: Should cv_upload be the location of the file on disk?
    add_column :users, :cv_link,  :string
    add_column :users, :cv_file,  :string

    # Additional sites
    add_column :users, :sites_open_science_framework, :boolean, null: false, default: false
    add_column :users, :sites_open_science_framework_url, :string

    add_column :users, :sites_researchgate, :boolean, null: false, default: false
    add_column :users, :sites_researchgate_url, :string

    add_column :users, :sites_linkedin, :boolean, null: false, default: false
    add_column :users, :sites_linkedin_url, :string

    add_column :users, :sites_vivo, :boolean, null: false, default: false
    add_column :users, :sites_vivo_url, :string

    add_column :users, :sites_institutional_repo, :boolean, null: false, default: false
    add_column :users, :sites_institutional_repo_url, :string

    add_column :users, :sites_other, :boolean, null: false, default: false
    add_column :users, :sites_other_url, :string

    # How will you use the VDC?
    add_column :users, :usage_deposit_files, :boolean, null: false, default: false
    add_column :users, :usage_use_files, :boolean, null: false, default: false
    add_column :users, :usage_use_tools_on_vdc_data, :boolean, null: false, default: false
    add_column :users, :usage_use_tools_on_external_data, :boolean, null: false, default: false
    add_column :users, :usage_contact_others, :boolean, null: false, default: false

    # Intended use
    add_column :users, :usage_description, :string

    # How long is your intended participation in the VDC?
    add_column :users, :usage_duration, :string, null: false, default: "unsure"

    # This will be the Fedora 4 UUID for the Vdc::Person object that
    # corresponds to a particular user
    add_column :users, :identifier_system, :string
  end
end
