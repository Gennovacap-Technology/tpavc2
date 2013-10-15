class ContactMailer < ActionMailer::Base
  default from: "noreply@tpavc.com"

  def contact_mail(form)
  	@form = form
  	mail(:to => form.email, :subject => "Thank you for contacting us!")
  end

  def admin_mail_copy(form)
  	@form = form
  	mail(:to => "gennovacap.sandbox@gmail.com", :subject => "Contact from the visa website")
  end
end
