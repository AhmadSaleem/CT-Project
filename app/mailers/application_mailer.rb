class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def calculate_points_email
    mail(to: ['talhajunaid65@gmail.com', 'ahmad@amblersaleem.com'], subject: 'Performance Points', body: "Performance Points calculated Successfully")
  end
end
