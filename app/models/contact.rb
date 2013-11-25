class Contact

	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	attr_accessor :name, :company, :email, :phone, :website

	validates_presence_of :name, 
						:company, 
						:email, 
						:phone, 
						:website

	validates_format_of :email, 
						:with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
						:message => "The e-mail must to be valid."

	validates_format_of :website, 
						:with => URI::regexp(%w(http https)),
						:message => "The URL should start with http:// or https:// to be valid."

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def persisted?
		false
	end

end