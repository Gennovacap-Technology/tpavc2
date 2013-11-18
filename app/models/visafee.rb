class Visafee < ActiveRecord::Base
  belongs_to :visa_entry
  attr_accessible :embassy_fees, :processing_time_from, :processing_time_to, :service_fees
  validates_presence_of :embassy_fees, :processing_time_from, :processing_time_to, :service_fees
end
