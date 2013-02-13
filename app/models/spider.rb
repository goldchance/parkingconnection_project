require 'mechanize'
require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"

class Spider
      
  include Capybara::DSL
  
  def get_results(location)
    results=[]
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "https://www.parkingpanda.com"
    
    visit("https://www.parkingpanda.com/Search/?location=#{location}&monthly=true&daily=false")
    
    all(:xpath, "//div[@class='location-details']/h2").each do |item|
      object = Hash.new
      object["location"]= item.text
      results<<object
    end
    all(:xpath, "//div[@class='location-details']/p").each_slice(2).with_index do |slice,index|
      if results[index-1].present?
        object = results[index-1]
        object["main"]= slice[0].text
      end
    end
    all(:xpath, "//span[@class='location-price']").each_with_index do |item,index|
      if results[index-1].present?
        object = results[index-1]
        object["price"]= item.text
      end
    end
  results
  end                                          
                                               
  #spider = Test::Google.new                   
  #spider.get_results                          
                                               
                                               

def self.search(params)
   agent = Mechanize.new
  page = agent.get("https://www.parkingpanda.com/Search/?location=Miami&start=2/11/2013#location=Miami%2C%20FL%2C%20USA&start=2/11/2013&monthly=false&daily=true")
 
 end
end
