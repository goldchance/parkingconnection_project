class Request < ActiveRecord::Base
 
  attr_accessible :desc
  has_many :results , :dependent => :destroy
end
