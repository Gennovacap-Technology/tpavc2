class PassportVisa < ActiveRecord::Base
  has_many :visa_entries, :dependent => :delete_all
  has_many :assets, :dependent => :delete_all
  belongs_to :country, foreign_key: :country_id

  accepts_nested_attributes_for :visa_entries, :allow_destroy => true
  accepts_nested_attributes_for :assets, :allow_destroy => true

  attr_accessible :visa_entries_attributes, :assets_attributes, :countries_attributes, :country_id, :citizenship, :visa_type, :visa_required, :maximum_stay, :requirements, :travel_warnings, :meta_title, :meta_description, :meta_keywords, :document_package, :supplemental_package
  attr_accessor :document_package, :supplemental_package
  validates_presence_of :country_id, :citizenship, :visa_type, :visa_required, :maximum_stay, :meta_title, :meta_description, :meta_keywords
  validates :travel_warnings, :length => { :maximum => 500 }
  validates :maximum_stay, :inclusion => 1..1000

  before_create :check_exists


  def check_exists
  	passport = PassportVisa.where(:visa_type => self.visa_type, :country_id => self.country, :citizenship => self.citizenship)
  	if passport.any?
  		self.errors.add(:visa_type, "This record already exists for this visa type")
  		self.errors.add(:citizenship, "This record already exists for this citizenship")
  		false
  	end
  end
end