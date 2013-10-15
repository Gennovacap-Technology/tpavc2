desc "Fill all the information about countries and states."
task :fill_countries_and_states => :environment do
	Rake::Task['db:seed'].invoke

	Country.all.each do |c|
    	c.update_attributes! :shortname => c.name.gsub(/[^0-9a-z]/i, '').downcase
    end
end