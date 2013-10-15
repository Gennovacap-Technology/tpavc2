class Label

	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	attr_accessor :name, :company, :phone_number, :address, :city, :state, :postal_code, :action_name

	validates_presence_of :name, 
						:company,
						:phone_number,
						:address,
						:city,
						:state,
						:postal_code

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def persisted?
		false
	end

end