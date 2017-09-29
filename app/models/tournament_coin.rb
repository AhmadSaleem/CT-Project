class TournamentCoin < ApplicationRecord
  belongs_to :tournament

  validates :coins, :start_standing, :end_standing, numericality: { greater_than: 0}, presence: true
  validate  :validate_standing

  #Custom Validations
  def validate_standing
    if start_standing > end_standing
      errors.add(:start_standing, "should be smaller than end_standing")
    end
  end
end
