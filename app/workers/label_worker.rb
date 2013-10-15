class LabelWorker
	include Sidekiq::Worker

	def perform(filename)
		File.delete("#{Rails.root}/public/#{filename}")
	end
end