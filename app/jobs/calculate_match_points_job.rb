class CalculateMatchPointsJob < ApplicationJob
  queue_as :default

  def perform(resource_id)
    CalculateMatchPoints.new(Match.find(resource_id)).call
  end
end
