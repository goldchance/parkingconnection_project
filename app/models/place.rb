class Place < ActiveRecord::Base
  attr_accessible :href, :location, :address, :price, :urlimage, :desc, :source_id
  belongs_to :source
end
