class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :teams, dependent: :destroy
  has_many :tournaments, through: :teams
  has_many :social_logins, dependent: :destroy
  SITES = [:google_oauth2, :facebook, :twitter]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: SITES

end
