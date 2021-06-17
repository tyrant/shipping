class ContactMailer < ApplicationMailer

  def contact(params = {})
    @name = params[:name]
    @email = params[:email]
    @phone = params[:phone]
    @message = params[:message]

    mail to: 'admin@nzsf.org.nz', from: params[:email], subject: "NZSF Inquiry from #{params[:name]}"
  end
end