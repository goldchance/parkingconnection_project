class Result < ActiveRecord::Base
  attr_accessible :owner, :location, :address, :price, :desc
end
