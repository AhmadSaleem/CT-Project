ActiveAdmin.register User  do

  permit_params :user_name, :email, :password, :password_confirmation, :available_coins, :admin

  form do |f|
    f.inputs "User Details" do
      f.input :user_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :available_coins
      f.input :admin, :label => "Super Administrator" ,as: :boolean
    end
    f.actions do
      f.action :submit, label: "Create Admin user", url: admin_users_path
      f.action :cancel, wrapper_html: { class: 'cancel'}
    end
  end

  index do
    selectable_column
    column :id
    column :user_name
    column :email
    column :available_coins
    column :admin
    column :current_sign_in_at
    column :sign_in_count
    actions
  end

  show do
    panel "User Details" do
      attributes_table_for user do
        row :user_name
        row :email
        row :available_coins
        row :admin
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :current_sign_in_at
        row :sign_in_count
      end
    end
  end
end
