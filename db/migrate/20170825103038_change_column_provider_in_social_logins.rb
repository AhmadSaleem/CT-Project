class ChangeColumnProviderInSocialLogins < ActiveRecord::Migration[5.1]
  def change
    rename_column :social_logins, :providers, :provider
  end
end
