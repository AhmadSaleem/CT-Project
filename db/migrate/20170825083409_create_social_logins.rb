class CreateSocialLogins < ActiveRecord::Migration[5.1]
  def change
    create_table :social_logins do |t|
      t.references   :user
      t.string       :email
      t.string       :providers
      t.string       :uid

      t.timestamps
    end
  end
end
