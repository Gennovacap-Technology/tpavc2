module HomeHelper

	# Show single errors on the contact form
	def display_contact_error(field)
	    if @contact.errors[field].any?
	      raw "<div class='error_message'>" + @contact.errors[field].first.capitalize + "</div>"
	    end
	end

	def display_renew_error(field)
	    if @renew.errors[field].any?
	      raw "<div class='error_message'>" + @renew.errors[field].first.capitalize + "</div>"
	    end
	end

	def display_label_error(field)
	    if @label.errors[field].any?
	      raw "<div class='error_message'>" + @label.errors[field].first.capitalize + "</div>"
	    end
	end

end