class HomeController < ApplicationController

  def index
  end

  def solutions
    @contact = Contact.new
  end

  def search
    # Params
    citizenship  = params[:citizenship]
    state        = params[:state]
    destination  = params[:destination]

    # Country
    @country = Country.find(destination)

    redirect_to visa_path(:country => @country.shortname, :state => state, :citizenship => citizenship)
  end

  def download_pdf
    # Find the asset
    @asset  = Asset.find(params[:id])

    # If there's no records, redirect
    if @asset.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    # Path to the file
    file    = File.join("#{Rails.root}/public/files", @asset.pdf_name)

    # Download link
    send_file file, :type => 'application/pdf', :disposition => 'attachment', :filename => "#{@asset.pdf_real_name}.pdf"
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
    Zip::ZipOutputStream.open(temp.path) do |z|
      @files.assets.each do |f|
        path = File.join("#{Rails.root}/public/files", f.pdf_name)
        z.put_next_entry("#{f.pdf_real_name}.pdf")
        z.print IO.read(path)
      end
    end

    # Make the download request
    send_file temp.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@country.name}.zip"
  end

  def contact
    @contact = Contact.new
  end

  def send_contact
    if params[:form_name] == "contact"
      pathname   = contact_path
      actionname = 'contact'
    else
      pathname   = solutions_path
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
