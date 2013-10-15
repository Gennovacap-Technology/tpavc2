class Renew

	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	attr_accessor :full_name, :email, :pdf1, :pdf2, :pdf3, :pdf4, :action_name

	validates_presence_of :full_name, 
						:email,
						:pdf1

	validates_format_of :email, 
						:with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
						:message => "The e-mail must to be valid."

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def persisted?
		false
	end

end