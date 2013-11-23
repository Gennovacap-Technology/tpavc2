require 'digest/md5'

ActiveAdmin.register PassportVisa, :as => "Visa" do

	menu :label => "Visas"

	index do
		column :country
		column :citizenship
		column :visa_type
		default_actions
	end

	show do |visa|
		panel "Main Information" do
			attributes_table_for visa do
				row("Country") {|visa| visa.country}
				row("Citizenship") {|visa| visa.citizenship}
				row("Visa Type") {|visa| visa.visa_type}
				row("Visa Required") {|visa| visa.visa_required}
				row("Maximum Stay") {|visa| visa.maximum_stay}
			end
		end
		div :class => "panel" do
			h3 "Entries"
			if visa.visa_entries and visa.visa_entries.count > 0
				table do
					thead do
						tr do
							th do
								"Type Of Entry"
							end
							th do
								"Maximum Validity"
							end
							th do
								"Processing Time"
							end
							th do
								"Embassy Fee"
							end
							th do
								"Service Fee"
							end
							th do
								"Total Cost"
							end
						end
					end
					tbody do
						visa.visa_entries.each do |e|
							tr do
								td do 
									e.type_of_entry
								end
								td do 
									"up to #{e.maximum_validity} days"
								end
								td do
									e.visafees.each do |v|
										div do
											"#{v.processing_time_from}-#{v.processing_time_to} business days"
										end
									end
								end
								td do
									e.visafees.each do |v|
										div do
											"$#{v.embassy_fees}"
										end
									end
								end
								td do
									e.visafees.each do |v|
										div do
											"$#{v.service_fees}"
										end
									end
								end
								td do
									e.visafees.each do |v|
										div do
											"$#{v.embassy_fees + v.service_fees}"
										end
									end
								end
							end
						end
					end
				end
			else
				"No Entries Available"
			end
		end
		panel "Uploads" do
			if visa.citizenship == "US Citizen"
				h4 :class => "documental_title" do
					"Document Package"
				end
				if visa.assets.any?
					visa.assets.each do |a|
						if a.pdf_type == "document"
							div :class => "pdf_item" do
								raw(a.pdf_real_name + " - " + link_to("Delete", :controller => "visas", :action => "delete_asset", :id => "#{a.id}") + " - " + link_to("Download", {:controller => "visas", :action => "download", :id => "#{a.id}"}, {:target => '_new'}))
							end
						end
					end
				else
					p "No PDFs"
				end
			end
			###################
			if visa.citizenship == "Foreign National"
				h4 :class => "documental_title" do
					"Supplement Package"
				end
				if visa.assets.any?
					visa.assets.each do |a|
						if a.pdf_type == "supplement"
							div :class => "pdf_item" do
								raw(a.pdf_real_name + " - " + link_to("Delete", :controller => "visas", :action => "delete_asset", :id => "#{a.id}") + " - " + link_to("Download", {:controller => "visas", :action => "download", :id => "#{a.id}"}, {:target => '_new'}))
							end
						end
					end
				else
					p do 
						"No PDFs" 
					end
				end
			end
		end
		panel "Travel Warnings" do
			attributes_table_for visa do
				row("Warnings") {|visa| visa.travel_warnings}
			end
		end
		panel "Requirements" do
			attributes_table_for visa do
				row("Requirements") {|visa| visa.requirements.html_safe}
			end
		end
	end

	# Filters
	filter :country
	filter :citizenship
	filter :visa_type

	breadcrumb do
		# Edit the breadcrumb
	end

	form :html => { :enctype => "multipart/form-data" } do |f|

		f.inputs "Main information" do
			f.input :country, :as => :select
			f.input :citizenship, :as => :radio, :collection => ["US Citizen", "Foreign National"]
			f.input :visa_type, :as => :select, :collection => ["Tourist", "Business", "Official", "Work", "Student"]
			f.input :visa_required, :label => "Is Visa Required?", :as => :radio, :collection => ["Required", "Not Required"]
			f.input :maximum_stay, :label => "Maximum Stay", :as => :string, :input_html => { :maxlength => 3 }
		end

		f.inputs "Entries" do
			f.has_many :visa_entries do |ff|
				ff.input :type_of_entry, :as => :select, :collection => ["Single Entry", "Multiple Entry"]
				ff.input :maximum_validity
				# add the fields here
				ff.has_many :visafees do |fff|
					fff.input :embassy_fees
					fff.input :service_fees
					fff.input :processing_time_from
					fff.input :processing_time_to
				end
			end
		end

		f.inputs "Document Attachments" do
			f.input :document_package, :as => :file, :input_html => {:multiple => true}
			f.input :supplemental_package, :as => :file, :input_html => {:multiple => true}
		end

		f.inputs "Requirements for Mailing in Documents" do
			f.input :travel_warnings, :as => :text, :input_html => {:rows => 5}
			f.input :requirements, :as => :ckeditor, :input_html => {:class => "ckeditor"}
		end

		f.action :submit, :label => "Create Visa", :button_html => { :class => "lagoon" }

	end

	############################
	# Controller Modifications #
	############################

	member_action :delete_asset do
		# Save the previous URL
		session[:return_to] = request.referer

		# Find the record
		@asset = Asset.find_by_id(params[:id])
		
		if @asset == nil
			flash[:error] = "The file doesn't exist."
			redirect_to session[:return_to]
		else
			# Delete the file from the system
			assets_path = "#{Rails.root}/public/files"
			path  			= File.join(assets_path, @asset.pdf_name)
			
			if File.delete(path)
				@asset.destroy
				flash[:notice] = "The File was deleted successfully!"
				redirect_to session[:return_to]
			else
				flash[:error] = "This file can't be deleted!"
				redirect_to session[:return_to]
			end
		end

	end

	member_action :download do
		# Save the previous URL
		session[:return_to] = request.referer

		# Find the record
		@asset = Asset.find_by_id(params[:id])
		
		if @asset == nil
			flash[:error] = "The file doesn't exist."
			redirect_to session[:return_to]
		else
			# Delete the file from the system
			assets_path = "#{Rails.root}/public/files"
			path  			= File.join(assets_path, @asset.pdf_name)
			
			send_file path, :type => 'application/pdf', :x_sendfile => true
		end
	end

	controller do

		def create(options={}, &block)

			@passport_visa = PassportVisa.new(params[:visa].except(:document_package, :supplemental_package))

			if @passport_visa.save
				visa_id = @passport_visa.id
				m_documents    = params[:visa][:document_package]
				m_supplements  = params[:visa][:supplemental_package]

				if m_documents != nil
					m_documents.each do |a|
						Asset.save_file(a, "document", visa_id)
					end
				end

				if m_supplements != nil
					m_supplements.each do |a|
						Asset.save_file(a, "supplement", visa_id)
					end
				end

				flash[:notice] = "The Visa was created successfully!"
				redirect_to :action => :index
			else
				super(options) do |success, failure|
	        block.call(success, failure) if block
	        failure.html { render active_admin_template('new') }
	      end
			end

		end

		def update(options={}, &block)

			@passport_visa = PassportVisa.find(params[:id])

			if @passport_visa.update_attributes(params[:visa].except(:document_package, :supplemental_package))
				visa_id = @passport_visa.id
				m_documents    = params[:visa][:document_package]
				m_supplements  = params[:visa][:supplemental_package]

				if m_documents != nil
					m_documents.each do |a|
						Asset.save_file(a, "document", visa_id)
					end
				end

				if m_supplements != nil
					m_supplements.each do |a|
						Asset.save_file(a, "supplement", visa_id)
					end
				end

				flash[:notice] = "The Visa was updated successfully!"
				redirect_to :action => :index
			else
	      super do |success, failure|
	        block.call(success, failure) if block
	        failure.html { render active_admin_template('edit') }
	      end
	    end
    end

	end


end