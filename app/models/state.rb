class State < ActiveRecord::Base
  attr_accessible :countries_id, :name, :iso
  belongs_to :country
end
