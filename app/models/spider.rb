require 'mechanize'
require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"

class Spider
      
  include Capybara::DSL
  
  def get_results_gottaprk(location,type)
     results=[]
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "http://www.gottapark.com/"
    visit("http://www.gottapark.com/")
    fill_in "search_key", :with =>"#{location}"
    find(:xpath,'//div[@id="homeboxbutton"]/input').click
    all(:xpath,'//div[@id="smallsearchbox"]/div/div[@class="details"]/p[@class="address"]').each do |item|
       object = Hash.new
       object["location"]= item.text
      results<<object
    end
   
    all(:xpath,'//div[@id="smallsearchbox"]/div/div[@class="details"]/p[@class="price"]').each_with_index do |item|
    if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["price"]= item.text
      end

    end
  
  results.each do |o|
      item = Result.new
      item.address = o["location"]
      item.location = o["location"]
      item.price = o["price"]
      if type =='daily'
       item.desc="daily"
      else
       item.desc="monthly"
      end 
      item.save
    end
  
  end
  
  
  
  def get_results(location,type)
    results=[]
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "https://www.parkingpanda.com"
    if type != 'daily'
      visit("https://www.parkingpanda.com/Search/?location=#{location}&monthly=true&daily=false")
    else
      visit("https://www.parkingpanda.com/Search/?location=#{location}&monthly=false&daily=true")
    end
    all(:xpath, "//div[@class='location-details']/h2").each do |item|
     #object = Result.new
     #object.address = item.text
       object = Hash.new
       object["location"]= item.text
      results<<object
    end
    all(:xpath, "//div[@class='location-details']/p").each_slice(2).with_index do |slice,index|
      if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["main"]= slice[0].text
      end
    end
    all(:xpath, "//span[@class='location-price']").each_with_index do |item,index|
      if results[index-1].present?
        #object.price = item.text
        object = results[index-1]
        object["price"]= item.text
        #object.save
      end
    end
  Result.delete_all
    results.each do |o|
      item = Result.new
      item.address = o["location"]
      item.location = o["main"]
      item.price = o["price"]
      if type =='daily'
       item.desc="daily"
      else
       item.desc="monthly"
      end 
      item.save
    end
  end                                          
                                               
  #spider = Test::Google.new                   
  #spider.get_results                          
                                               
                                               

def self.search(params)
   agent = Mechanize.new
  page = agent.get("https://www.parkingpanda.com/Search/?location=Miami&start=2/11/2013#location=Miami%2C%20FL%2C%20USA&start=2/11/2013&monthly=false&daily=true")
 
 end
end
