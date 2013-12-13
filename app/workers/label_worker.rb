class LabelWorker
	include Sidekiq::Worker

	def perform(filename)
		s3        = AWS::S3.new
	    b         = s3.buckets[ENV['S3_BUCKET_NAME']]
	    o         = b.objects[filename]
	    o.delete
	end
end