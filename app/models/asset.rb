class Asset < ActiveRecord::Base
  belongs_to :passport_visa
  # before_destroy :delete_files
  
  def self.save_file(file, type, id)
  	assets_path		 			= "#{Rails.root}/public/files"
  	file_original_name 	= file.original_filename.split('.').first
		file_original_ex 	  = file.original_filename.split('.').last
		file_new_name				= Digest::MD5.hexdigest(Time.now.to_s + file_original_name) + ".#{file_original_ex}"

		@asset = Asset.new
		@asset.passport_visa_id = id
		@asset.pdf_name = file_new_name
		@asset.pdf_real_name = file_original_name.capitalize
		@asset.pdf_type = type

		if @asset.save
			path = File.join(assets_path, file_new_name)
			File.open(path, "wb") { |f| f.write(file.read) }
		end
  end

  protected

  # def delete_files
  # 	@files = Asset.where("passport_visa_id = ?", params[:id])
  # 	@files.each do |file|
  # 		assets_path	= "#{Rails.root}/public/files"
  # 		path 				= File.join(assets_path, file.pdf_name)
  # 		File.delete(path)
  # 	end
  # end
end