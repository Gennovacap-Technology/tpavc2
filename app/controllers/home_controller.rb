class HomeController < ApplicationController

  def index
    # SEO
    @page_title       = 'Expedited Passport Renewal Services Austin - Same Day Visa Houston & Dallas, TX | 1-888-GO-PASSPORT '
    @page_description = 'The Passport & Visa Company provides expedited passport renewal and same day visa services. The Passport & Visa Company\'s works in conjunction with the U.S. State Department, U.S. Passport Agencies, Foreign Embassies and Consulates to speed up your travel documents.'
    @page_keywords    = 'us passport service, expedited passport, us passports, expedited passport renewal, expedited passport services, Expedited U.S. Passports, additional passport pages, childrens passport, passport name changes, second passport, lost passport, China Visa, India Visa, Russian Visa, Brazil Visa'
    set_meta_tags :canonical => 'http://www.thepassportandvisacompany.com'
  end

  def passportandvisasolutions
    @contact = Contact.new
    # SEO
    @page_title       = 'Customized Corporate Passport Solutions and Visa Solutions - Customized Passport and Visa Programs | Austin, Houston, Dallas '
    @page_description = 'The Passport & Visa Company provides expedited passport solutions and visa solutions for corporations and businesses. The customized corporate solutions and account management services are great for large enterprises.'
    @page_keywords    = 'Passport Solutions, Visa Solutions, Passport business solutions'
    set_meta_tags :canonical => 'http://www.thepassportandvisacompany.com/passportandvisasolutions'
  end

  def globalentryprogram
    # SEO
    @page_title       = 'Global Entry Program | Austin, Houston, Dallas'
    @page_description = 'The Passport & Visa Company provides assistance with the US state department\'s Global Entry Program.'
    @page_keywords    = 'U.S Department of State Global Entry Program, Global Entry, Global Entry Program'
    set_meta_tags :canonical => 'http://www.thepassportandvisacompany.com/globalentryprogram'
  end 

  def search
    # Params
    citizenship  = params[:citizenship]
    state        = params[:state]
    destination  = params[:destination]

    # Country
    country = Country.find(destination)

    redirect_to visa_path(:country => country.shortname, :state => state, :citizenship => citizenship)
  end

  def sitemap

  end  

  def download_pdf
    # Find the asset
    @asset  = Asset.find(params[:id])

    # If there's no records, redirect
    if @asset.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    # Download the file from the system
    s3          = AWS::S3.new
    b           = s3.buckets[ENV['S3_BUCKET_NAME']]
    file        = b.objects[@asset.pdf_name]

    require 'open-uri'
    url = file.url_for(:read).to_s
    data = open(url).read
    send_data data, :disposition => 'attachment', :filename=>"#{@asset.pdf_real_name}.pdf", :type => "application/pdf"
  end

  def download_package
    gem 'rubyzip'
    require 'zip/zip'
    require 'zip/zipfilesystem'

    # Get the params
    id       = params[:id]
    document = params[:document]

    # Find the files
    @files   = PassportVisa.includes(:assets).where(:assets => {:pdf_type => document}).find(id)
    @country = Country.find(@files.country_id)

    # Compile the files
    temp = Tempfile.new("zip-file-#{Time.now}")
    # Zip::ZipOutputStream.open(temp.path) do |z|
    #   @files.assets.each do |f|
    #     # Download the file from the system
    #     s3          = AWS::S3.new
    #     b           = s3.buckets[ENV['S3_BUCKET_NAME']]
    #     file        = b.objects[f.pdf_name]

    #     require 'open-uri'
    #     url = file.url_for(:read).to_s
    #     data = open(url).read

    #     z.put_next_entry("#{f.pdf_real_name}.pdf")
    #     z.print IO.read(data.write)
    #   end
    # end

    # Zip::ZipOutputStream.open(temp.path) do |z|
    #   @files.assets.each do |f|
    #     file = b.objects[f.pdf_name]
    #     file.read do |chunk|
    #       z.put_next_entry("#{f.pdf_real_name}.pdf")
    #       z.print IO.write("#{f.pdf_real_name}.pdf", chunk)
    #     end
    #   end
    # end

    # Make the download request
    #send_file temp.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@country.name}.zip"

    require 'open-uri'
    require 'httparty'
    require 'json'
    s3                        = AWS::S3.new
    b                         = s3.buckets[ENV['S3_BUCKET_NAME']]
    download_manifest         = {
      "name"  => @country.name.capitalize,
      "files" => []
    }

    @files.assets.each do |f|
      file = b.objects[f.pdf_name]
      download_manifest['files'] << {path: "#{f.pdf_real_name}.pdf", url: file.url_for(:read).to_s}
    end

    options = {:headers => { 'Content-Type' => 'application/json' },
              :basic_auth => {
                :username => ENV['DOWNLOADER_ID'],
                :password => ENV['DOWNLOADER_SECRET']
              },
              :body => download_manifest.to_json}

    response = HTTParty.post("#{ENV['DOWNLOADER_URL']}/downloads", options)

    redirect_to response['url']
  end

  def contact
    @contact = Contact.new
  end

  def send_contact
    if params[:form_name] == "contact"
      pathname   = '/contact'
      actionname = 'contact'
    else
      pathname   = '/passportandvisasolutions'
      actionname = 'solutions'
    end

    @contact = Contact.new(params[:contact].except(:form_name))
    if @contact.valid?
      # send the email
      ContactMailer.contact_mail(@contact).deliver
      ContactMailer.admin_mail_copy(@contact).deliver
      flash[:notice] = "Your form was sent with success!"
      redirect_to pathname
    else
      render :action => actionname
    end
  end

end
