class VisaEntry < ActiveRecord::Base
  belongs_to :passport_visa
  attr_accessible :type_of_entry, :maximum_validity, :embassy_fees, :service_fees, :processing_time
  validates_presence_of :type_of_entry, :maximum_validity, :embassy_fees, :service_fees, :processing_time
end