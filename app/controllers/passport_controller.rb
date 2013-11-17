class PassportController < ApplicationController

  	def downloadpassports
  		 @page_title       = 'Expedited Passport Renewal, Additional Passport Pages, New Children Passport, New Minor Passport, New Adult Passport, Name Change Passport, Secondary Passport, Add Visa Pages | Austin, Tx Houston, Tx & Dallas, TX'
   		 @page_description = 'The Passport & Visa Company provides expedited passport renewal and same day visa services. Expedited Passport Renewal, Additional Passport Pages, New Children Passport, New Minor Passport, New Adult Passport, Name Change Passport, Secondary Passport, Add Visa Pages  '
   		 @page_keywords    = 'us passport service, expedited passport, us passports, expedited passport renewal, expedited passport services, new adult passport, new us passport, new expedited passport, passport renewal, renewal of passport, renew passport us, usa renew passport, passport renewal austin, passport renewal, new passport, renew us passport, renewal of passport, additional passport pages, adding passport pages, add pages to passport expedited, children passport, childrens passport, children passport renewal, children passports, children passport photos, united states passport name change, passport name change marriage, change of name on passport, passport name changes, how to change name on passport, get a second passport, second passport, apply for second passport, duplicate passport, second passport us, stolen passport, lost passport, passport replacement, lost or stolen passport, lost passport united states'
    	 set_meta_tags :canonical => 'http://www.thepassportandvisacompany.com/passport/download'
  	end	

	def newadultpassport
		@renew = Renew.new
		@label = Label.new
	end

	def newminorpassport
		@renew = Renew.new
		@label = Label.new
	end

	def newpassport
	end

	def secondpassport
		@renew = Renew.new
		@label = Label.new
	end

	def lostpassport
		@renew = Renew.new
		@label = Label.new
	end

	def namepassport
		@renew = Renew.new
		@label = Label.new
	end

	def addpagespassport
		@renew = Renew.new
		@label = Label.new
	end

	def renewpassport
		@renew = Renew.new
		@label = Label.new
	end

	def send_renew
		@renew = Renew.new(params[:renew])
		@label = Label.new
		action = @renew.action_name

		if @renew.valid?
			# send the email
			RenewMailer.renew_mail(@renew).deliver
			
			flash[:notice] = "Your form was sent with success!"
			redirect_to "#{action}_path"
		else
			render :action => action
		end
	end

	def send_label
		@label = Label.new(params[:label])
		@renew = Renew.new
		action = @label.action_name

		if @label.valid?
			# Generate the Label
			shipper = { 
				:name => @label.name,
				:company => @label.company,
				:phone_number => @label.phone_number,
				:address => @label.address,
				:city => @label.city,
				:state => @label.state,
				:postal_code => @label.postal_code,
				:country_code => "US"
			}

			recipient = { 
				:name => "Pauline Salzer",
				:company => "The Passport and Visa Company",
				:phone_number => "555-555-5555",
				:address => "1145 w. 5th street Suite 307",
				:city => "Austin",
				:state => "TX",
				:postal_code => "78703",
				:country_code => "US",
				:residential => "false" 
			}

			packages = []
			packages << {
				:weight => {:units => "LB", :value => 2},
				:dimensions => {:length => 10, :width => 5, :height => 4, :units => "IN" }
			}

			shipping_details = {
				:packaging_type => "YOUR_PACKAGING",
				:drop_off_type => "REGULAR_PICKUP"
			}

			require 'fedex'
			fedex = Fedex::Shipment.new(
				:key => 'qeYNLLAUJVAOenK7',
				:password => '4Ei8OGSgkTIiJDhf6wPTnQD6t',
				:account_number => '510087623',
				:meter => '118585714',
				:mode => 'development'
			)

			filename = "label#{Date.new.to_time.to_i}.pdf"

			label = fedex.label(:filename => "public/#{filename}",
					:shipper=>shipper,
					:recipient => recipient,
					:packages => packages,
					:service_type => "FEDEX_GROUND",
					:shipping_details => shipping_details)

			# Schedule the file delete
			LabelWorker.perform_in(5.minutes, filename)

			redirect_to "/#{filename}"

		else
			render :action => action
		end
	end

end
