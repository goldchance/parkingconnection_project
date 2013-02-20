require 'mechanize'
require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"

class Spider
  TIME_VALUE={ }    
  include Capybara::DSL
  
  def self.daily_search(params)
    #begin
      Result.delete_all
      spy=Spider.new
      spy.get_results_gottapark(params,"daily")
      spy.get_results_pandaparking(params, "daily")
      spy.get_results_centralpark(params, "daily")
   # rescue Exception => e  
    #  puts e.message  
     # puts e.backtrace.inspect  
    #end
  end
 
  def self.monthly_search(location)
    begin 
      spy=Spider.new
      spy.get_results_pandaparking(location, "monthly")
      spy.get_results_centralpark(location, "monthly")
    rescue Exception => e  
      puts e.message  
      puts e.backtrace.inspect  
    end
  end
  
    
  def self.airports_search(location)
    spy=Spider.new
    spy.get_results_gottapark(location,"monthly")
    spy.get_results_pandaparking(location, "monthly")
  end
#-------------------------------------------- www.gottaprk.com -------------------------------------  
  def get_results_gottapark(params,type)
     results=[]
    location=params[:wherebox]
    if location.present?
     arr = location.split(",")
     city = arr[0].strip.gsub(" ","-")
     state = arr[1].strip
    end
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "http://www.gottapark.com/"
    visit("http://www.gottapark.com/")
    fill_in "search_key", :with =>"#{location}"
    fill_in "date_from", :with =>"#{params[:from].gsub("/","-")}"
    #fill_in "time_from", :with =>"#{params[:items]}"
    select "#{params[:Items]}", :from=>"time_from"
    fill_in "date_to", :with =>"#{params[:to].gsub("/","-")}"
    #fill_in "time_to", :with =>"#{params[:items2]}"
    select "#{params[:Items2]}", :from=>"time_to"
    find(:xpath,'//div[@id="homeboxbutton"]/input').click
    all(:xpath,'//div[@id="smallsearchbox"]/div/div[@class="details"]/p[@class="address"]').each do |item|
       object = Hash.new
       object["location"]= item.text
      results<<object
    end
   
    all(:xpath,'//p[@class="price"]').each_with_index do |item,index|
    if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["price"]= item.text[0..-3]
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
  
#------------------------------------  www.pandaparking.com --------------------------------------------
  
  def get_results_pandaparking(params,type)
    location = params[:wherebox]
    results=[]
    arr = location.split(",")
    city = arr[0].strip.gsub(" ","-")
    state = arr[1].strip 
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "https://www.parkingpanda.com"
    if type != 'daily'
      visit("https://www.parkingpanda.com/Search/?location=#{city}&start=#{params[:from]}&end=#{params[:to]}3&monthly=true&daily=false")
    else
      visit("https://www.parkingpanda.com/Search/?location=#{city}&monthly=false&daily=true")
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

#-------------------------------------  www.centralparking.com -------------------------------------------------  
                                               
                                               
def get_results_centralpark(params,type)
    location = params[:wherebox]
    results=[]
    arr = location.split(",")
    city = arr[0].strip.gsub(" ","-")
    state = arr[1].strip 
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "https://www.parkingpanda.com"
    visit("http://#{city}.centralparking.com/parking-near/#{city}-#{state}-USA.html")
    list=[]
    all(:css,'.hasCoupon td.itemLabel a').each do |url|
      list << url[:href]
      
    end
    
    list.each do |url|
      visit("http://#{city}.centralparking.com#{url}")
      object = Hash.new
      object["location"] = all(:css,"dl.info dd").first.text
      object["main"] = all(:css,"dl.info dd").first.text
      
      object["price"] = all(:css, "table.layout-table-1 tr td")[3].text
      results<<object
    end
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

  
  
#---------------------------------------------------------------------------------------------------------------  
  def self.search(params)
   agent = Mechanize.new
  page = agent.get("https://www.parkingpanda.com/Search/?location=Miami&start=2/11/2013#location=Miami%2C%20FL%2C%20USA&start=2/11/2013&monthly=false&daily=true")
 
 end
end
