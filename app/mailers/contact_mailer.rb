class ContactMailer < ApplicationMailer

  def contact(params={})
    @name = params[:name]
    @email = params[:email]
    @phone = params[:phone]
    @message = params[:message]

    # Actual email to send: annabel.young@shipfed.co.nz
    mail to: 'epicschnozz@gmail.com', from: params[:email], subject: "NZSF Inquiry from #{params[:name]}"
  end
end