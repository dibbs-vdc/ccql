class AddRegistrationFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :vdc_referral_method, :string
    add_column :users, :vdc_referral_method_other, :string
    add_column :users, :first_name,  :string, null: false, default: ''
    add_column :users, :last_name,  :string, null: false, default: ''
    add_column :users, :organization,  :string, null: false, default: ''
    add_column :users, :organization_other,  :string
    add_column :users, :vdc_role,  :string, null: false, default: ''
    add_column :users, :vdc_role_other,  :string
    add_column :users, :discipline,  :string, null: false, default: ''
    add_column :users, :discipline_other,  :string
    add_column :users, :edu_person_principal_name,  :string, null: false, default: ''
    add_column :users, :cv_link,  :string

    add_column :users, :collaboration_open_science_framework, :boolean
    add_column :users, :collaboration_linkedin, :boolean, null: false, default: false
    add_column :users, :collaboration_vivo, :boolean, null: false, default: false
    add_column :users, :collaboration_institutional_repo, :boolean, null: false, default: false
    add_column :users, :collaboration_institutional_repo_name, :string
    add_column :users, :collaboration_other, :string

    add_column :users, :usage_deposit_files, :boolean, null: false, default: false
    add_column :users, :usage_use_files, :boolean, null: false, default: false
    add_column :users, :usage_use_tools_on_vdc_data, :boolean, null: false, default: false
    add_column :users, :usage_use_tools_on_external_data, :boolean, null: false, default: false
    add_column :users, :usage_description, :string
    add_column :users, :usage_duration, :string, null: false, default: "unsure"
    
  end
end
