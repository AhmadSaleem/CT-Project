class PlayerPerformanceScraperJob < ApplicationJob
  queue_as :default

  def perform(resource_id)
    match = Match.find(resource_id)
    PlayerPerformanceScraper.new(match).create_performance
  end

end
