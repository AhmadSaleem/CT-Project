class SocialLogin < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(auth)
    account = SocialLogin.find_by(provider: auth.provider, uid: auth.uid)
    return account.user if account.present?

    user = User.find_by(email: auth.info.email) || User.create(email: auth.info.email, user_name: auth.info.name, password: Devise.friendly_token[0,20])
    user.social_logins.create(email: auth.info.email, provider: auth.provider, uid: auth.uid)
    user
  end
end
