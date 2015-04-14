class ContactController < ApplicationController

  def contact
    ContactMailer.contact(
      name:    params[:name],
      email:   params[:email],
      phone:   params[:phone],
      message: params[:message]
    ).deliver_now

    flash[:notice] = "Email sent! Thanks for your feedback, we'll get in touch."
  end
end