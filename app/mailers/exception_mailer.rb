class ExceptionMailer < ApplicationMailer
  def exception_mail(message)
    mail(to: ['talhajunaid65@gmail.com', 'ahmad@amblersaleem.com'], subject: 'Error in importing data', body: "operation Failed: #{message}")
  end
end
