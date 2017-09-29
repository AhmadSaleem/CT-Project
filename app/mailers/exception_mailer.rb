class ExceptionMailer < ApplicationMailer
  def exception_mail(message)
    @message = message
    mail(to: ['talhajunaid65@gmail.com', 'ahmad@amblersaleem.com'],
        subject: 'Error in importing data')
  end
end
