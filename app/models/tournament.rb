class Tournament < ApplicationRecord
  has_many :tournament_players, dependent: :destroy
  has_many :players, through: :tournament_players

  accepts_nested_attributes_for :tournament_players, reject_if: :all_blank, allow_destroy: true
  validates :title, :format, presence: true
  validates :coins_required, :budget, :modifications_limit,
    numericality: { greater_than: 0 }, presence: true

end
