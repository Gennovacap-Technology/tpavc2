class Country < ActiveRecord::Base
  attr_accessible :iso, :name, :shortname
  has_many :states
  has_many :passport_visa, foreign_key: :country_id
end
