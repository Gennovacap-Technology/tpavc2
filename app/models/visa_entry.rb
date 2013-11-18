class VisaEntry < ActiveRecord::Base
  belongs_to :passport_visa
  has_many :visafees, :dependent => :delete_all

  accepts_nested_attributes_for :visafees, :allow_destroy => true
  
  attr_accessible :visafees_attributes, :type_of_entry, :maximum_validity
  validates_presence_of :type_of_entry, :maximum_validity
end