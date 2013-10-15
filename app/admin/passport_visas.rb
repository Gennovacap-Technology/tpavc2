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
		panel "Entries" do
			table_for visa.visa_entries do
				column "Type Of Entry" do |entry|
					entry.type_of_entry
				end
				column "Maximum Validity" do |entry|
					"up to #{entry.maximum_validity} days"
				end
				column "Processing Time" do |entry|
					"#{entry.processing_time} days"
				end
				column "Embassy Fees" do |entry|
					"$#{entry.embassy_fees}"
				end
				column "Service Fees" do |entry|
					"$#{entry.service_fees}"
				end
				column "Total Fees" do |entry|
					"$#{entry.embassy_fees+entry.service_fees}"
				end
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
					No PDFs
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
					No PDFs
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
			f.input :maximum_stay, :label => "Maximum Stay"
		end

		f.inputs "Entries" do
			f.has_many :visa_entries do |ff|
				ff.input :type_of_entry, :as => :select, :collection => ["Single Entry", "Multiple Entry"]
				ff.input :maximum_validity
				ff.input :embassy_fees
				ff.input :service_fees
				ff.input :processing_time
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

		f.actions

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