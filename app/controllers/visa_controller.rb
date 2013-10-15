class VisaController < ApplicationController

	def index
	end

	def visa
		# Params
		citizenship_type = {'us-citizen' => 'US Citizen', 'foreign-citizen' => 'Foreign Citizen'}
		@citizenship  = citizenship_type[params[:citizenship]]
		@state        = params[:state]
		@destination  = params[:country]

		# Country
		@country = Country.find_by_shortname(@destination)

		# Visas
		@visa_all       = PassportVisa.includes([:assets, :country]).uniq.where(:country_id => @country.id, :citizenship => @citizenship).count
		if @visa_all > 0
			@visa_tourist   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Tourist', :country_id => @country.id, :citizenship => @citizenship)
			@visa_official  = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Official', :country_id => @country.id, :citizenship => @citizenship)
			@visa_business  = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Business', :country_id => @country.id, :citizenship => @citizenship)
			@visa_work      = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Work', :country_id => @country.id, :citizenship => @citizenship)
			@visa_student   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Student', :country_id => @country.id, :citizenship => @citizenship)
		end
	end

	def downloadvisas
		# Documents
		@passport_visa_document_t   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Tourist', :assets => {:pdf_type => 'document'}).order("countries.name ASC")
		@passport_visa_document_b   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Business', :assets => {:pdf_type => 'document'}).order("countries.name ASC")
		@passport_visa_document_o   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Official', :assets => {:pdf_type => 'document'}).order("countries.name ASC")
		@passport_visa_document_w   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Work', :assets => {:pdf_type => 'document'}).order("countries.name ASC")
		@passport_visa_document_s   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Student', :assets => {:pdf_type => 'document'}).order("countries.name ASC")
		# Supplements
		@passport_visa_supplement_t   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Tourist', :assets => {:pdf_type => 'supplement'}).order("countries.name ASC")
		@passport_visa_supplement_b   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Business', :assets => {:pdf_type => 'supplement'}).order("countries.name ASC")
		@passport_visa_supplement_o   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Official', :assets => {:pdf_type => 'supplement'}).order("countries.name ASC")
		@passport_visa_supplement_w   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Work', :assets => {:pdf_type => 'supplement'}).order("countries.name ASC")
		@passport_visa_supplement_s   = PassportVisa.includes([:assets, :country]).uniq.where(:visa_type => 'Student', :assets => {:pdf_type => 'supplement'}).order("countries.name ASC")
	end

end
