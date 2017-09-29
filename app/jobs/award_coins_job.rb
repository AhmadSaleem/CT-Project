class AwardCoinsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    tournament = Tournament.find(resource.id)
    tournament.award_coins
  end
end
