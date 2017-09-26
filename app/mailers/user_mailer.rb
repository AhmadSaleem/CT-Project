class UserMailer < ApplicationMailer
  def calculate_points
    mail(to: ['talhajunaid65@gmail.com', 'ahmad@amblersaleem.com'],
        subject: 'Performance Points')
  end
end
