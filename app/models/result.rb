class Result < ActiveRecord::Base
  attr_accessible :owner, :location, :address, :price, :desc, :gmaps4rails_address, :latitude, :longitude, :gmaps
acts_as_gmappable

def gmaps4rails_address
#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
  "#{self.address}" 
end

def gmaps4rails_infowindow
  "<h5>#{location}</h5>" << "<h5>#{address}</h5>" <<"<p>#{price}</p>" <<"<a href=#{href} target='_blank' >#{source} </a>"
end
end
