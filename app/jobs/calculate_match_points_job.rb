class CalculateMatchPointsJob < ApplicationJob
  queue_as :default

  def perform(resource_id)
    CalculateMatchPoints.new(Match.find(resource_id)).call
    ApplicationMailer.calculate_points_email.deliver_later
  end

end
