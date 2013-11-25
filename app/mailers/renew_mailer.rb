class RenewMailer < ActionMailer::Base
  default from: "\"Visa Company\" <noreply@tpavc.com>"

  def renew_mail(form)
  	# Create a form instance
  	@form = form
  	
  	# The first file is required, no need to verify that
  	attachments[form.pdf1.original_filename] = File.read(form.pdf1.tempfile)
  	
  	if !form.pdf2.nil?
  		attachments[form.pdf2.original_filename] = File.read(form.pdf2.tempfile)
  	end
  	if !form.pdf3.nil?
  		attachments[form.pdf3.original_filename] = File.read(form.pdf3.tempfile)
  	end
  	if !form.pdf4.nil?
  		attachments[form.pdf4.original_filename] = File.read(form.pdf4.tempfile)
  	end

  	# Mail to pauline@tpavc.com if in production
  	mail(:to => "info@tpavc.com", :subject => "Renewal Request")
  end

end
