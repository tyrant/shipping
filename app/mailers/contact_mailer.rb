class ContactMailer < ApplicationMailer

  def contact(params={})
    @name = params[:name]
    @email = params[:email]
    @phone = params[:phone]
    @message = params[:message]

    mail to: 'epicschnozz@gmail.com', from: 'deathtomosttyrants@gmail.com', subject: 'blargh'
  end
end