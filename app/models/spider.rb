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
    begin
      Result.delete_all
      spy=Spider.new
      spy.get_results_gottapark(params,"daily")
      spy.get_results_pandaparking(params, "daily")
      spy.get_results_centralpark(params, "daily")
      result_string = ApplicationController.new.render_to_string(:partial => 'pages/results', :locals => { result_type: "daily" })
      message = {:channel => "/searches",
                 :data => { result_string: result_string}}
      uri = URI.parse("http://localhost:3000/faye")
      Net::HTTP.post_form(uri, :message => message.to_json)
   rescue Exception => e  
     puts e.message  
     puts e.backtrace.inspect  
    end
  end
 
  def self.monthly_search(params)
    begin 
      Result.delete_all
      spy=Spider.new
      spy.get_results_pandaparking(params, "monthly")
      spy.get_results_centralpark(params, "monthly")
      # FayeController.publish('/searches', {result_string: result_string})
      result_string = ApplicationController.new.render_to_string(:partial => 'pages/results', :locals => { result_type: "monthly" })
      message = {:channel => "/searches",
                 :data => { result_string: result_string}}
      uri = URI.parse("http://localhost:3000/faye")
      Net::HTTP.post_form(uri, :message => message.to_json)
    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end
  
    
  def self.airport_search(params)
     begin 
      Result.delete_all
      spy=Spider.new
      spy.get_results_airportparkingreservations(params)
      spy.get_results_parkingconnection(params)
      # FayeController.publish('/searches', {result_string: result_string})
      result_string = ApplicationController.new.render_to_string(:partial => 'pages/results', :locals => { result_type: "airport" })
      message = {:channel => "/searches",
                 :data => { result_string: result_string}}
      uri = URI.parse("http://localhost:3000/faye")
      Net::HTTP.post_form(uri, :message => message.to_json)
    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
    
  end
#------------------------------------airport search methods -----------------------------------------------------------
  #--------------------  http://www.parkingconnection.com/
def get_results_parkingconnection(params)
   begin 
    results=[]
    city=params[:wherebox_airp].split(" (")[0].gsub(" ","-")
    short_name = params[:wherebox_airp].split(" (")[1].gsub("(","").gsub(")","")
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "http://www.airportparkingreservations.com/"
    url="http://www.parkingconnection.com/locations/#{city}-#{short_name}-airport-parking/?dpnLocations=#{short_name}&txtCheckinDt=3/4/2013&dpnCheckInTime=12:00AM&txtCheckoutDt=3/10/2013&dpnCheckOutTime=12:00AM&UnitID&FacilityID&sendbutton2"
    #url="http://www.parkingconnection.com/locations/albany-alb-airport-parking/?dpnLocations=ALB&txtCheckinDt=3/4/2013&dpnCheckInTime=12:00AM&txtCheckoutDt=3/10/2013&dpnCheckOutTime=12:00AM&UnitID&FacilityID&sendbutton2"
    visit(url)
    sleep 5
    all(:css,"div.locationLot h3").each do |item|
      object = Hash.new
      object["main"]= item.text
      results<<object
    end

       
    all(:css, "div.locationLot span").each_with_index do |item,index|
      if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["main"] << item.text
      end
    end
    
    all(:css, "p.locationAddress").each_with_index do |item,index|
      if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["location"] = item.text
      end
    end

    all(:css, "div.locationLot div.rateInfoContainer div.rate").each_with_index do |item,index|
      if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["price"] = item.text
      end
    end
  
    all(:css, "p.facilityID").each_with_index do |item,index|
      if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["facilityid"] = item.text
      end
    end
    
    all(:css, "p.unitID").each_with_index do |item,index|
      if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["unitid"] = item.text
      end
    end
    
    results.each do |o|
      item = Result.new
      item.address = o["location"]
      item.location = o["main"]
      item.price = o["price"]
      item.href = "https://www.airportparkingconnection.com/apc/api/Checkout.aspx?dpnLocations=#{short_name}&txtCheckinDt=3%2F4%2F2013&dpnCheckInTime=12%3A00+AM&txtCheckoutDt=3%2F10%2F2013&dpnCheckOutTime=12%3A00+AM&UnitID=#{o["unitid"]}&FacilityID=#{o["facilityid"]}&sendbutton2="
      item.desc="airport"
      item.save
    end
  rescue Exception => e  
     puts e.message  
     puts e.backtrace.inspect  
    end
  end



  def get_results_airportparkingreservations(params)
   begin 
    results=[]
    url = params[:wherebox_airp_full]
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "http://www.airportparkingreservations.com/"
    visit(url)
    sleep 5
    all(:css, "div.sr-v3-left div.headline").each do |item|
      object = Hash.new
      object["location"]= item.text
      results<<object
    end

       
    all(:css, "div.sr-v3-right div.reserve-box em.price").each_with_index do |item,index|
      if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["price"]= item.text
      end
    end

  all(:css, "a.more-info").each_with_index do |item,index|
      if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["href"]= "http://www.airportparkingreservations.com#{item[:href]}"
      end
    end
  results.each do |o|
      item = Result.new
      item.address = o["location"]
      item.location = o["location"]
      item.price = o["price"]
      item.href = o["href"]
      item.desc="airport"
      item.save
    end
  rescue Exception => e  
     puts e.message  
     puts e.backtrace.inspect  
    end
  end
 #------------------------------------------------------- 
def get_results_cheapairportparking(params)
   begin 
    results=[]
    short_name = params[:wherebox_airp].split(" ")[1].gsub("(","").gsub(")","")
    url = params[:wherebox_airp_full]
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "http://www.airportparkingreservations.com/"
    "http://www.cheapairportparking.org/parking/find.php?airport=#{short_name}&FromDate=03%2F05%2F2013&from_time=1&ToDate=03%2F06%2F2013&to_time=15"
    visit(url)
    sleep 5
    all(:css, "div.sr-v3-left div.headline").each do |item|
      object = Hash.new
      object["location"]= item.text
      results<<object
    end

       
    all(:css, "div.sr-v3-right div.reserve-box em.price").each_with_index do |item,index|
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
      item.desc="airport"
      item.save
    end
  rescue Exception => e  
     puts e.message  
     puts e.backtrace.inspect  
    end
  end

  
  
#-------------------------------------------- www.gottaprk.com -------------------------------------  
  def get_results_gottapark(params,type)
   begin 
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
    
    all(:css, "p.title a").each_with_index do |item,index|
    if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        object["main"]= item.text
      end
    end


    all(:css, "p.address").each_with_index do |item,index|
    if results[index-1].present?
      #  object.location = slice[0].text
        object = results[index-1]
        path=item.text.split(",").first.gsub(" ","-")
        object["href"]= "http://www.gottapark.com/parking/#{city}/#{path}"
      end

    end

    
    results.each do |o|
      item = Result.new
      item.address = o["location"]
      item.location = o["main"]
      item.href = o["href"]
      item.price = o["price"]
      if type =='daily'
       item.desc="daily"
      else
       item.desc="monthly"
      end 
      item.save
    end
  rescue Exception => e  
     puts e.message  
     puts e.backtrace.inspect  
    end
  end
  
#------------------------------------  www.pandaparking.com --------------------------------------------
  
  def get_results_pandaparking(params,type)
   begin
    location = params[:wherebox]
    results=[]
    arr = location.split(",")
    city = arr[0].strip.gsub(" ","-")
    state = arr[1].strip 
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "https://www.parkingpanda.com"
    if type != 'daily'
      # visit("https://www.parkingpanda.com/Search/?location=#{city}&start=#{params[:from]}&end=#{params[:to]}3&monthly=true&daily=false")
      visit "https://www.parkingpanda.com"
      fill_in "ctl00$container$txtSearch", :with =>"#{city}, #{state}, USA"
      fill_in "ctl00$container$txtSearchStartDate", :with => "02/23/2013"
      find(:xpath, '//input[@name="ctl00$container$btnSearch"]').click
      if all(:xpath,'//a[@id="lnkMonthlyParking"]').size>0
	all(:xpath,'//a[@id="lnkMonthlyParking"]').first.click
	
	sleep 5
	#debugger
  if all(:css, "span.location-rate").size>0
   if all(:css, "span.location-rate").first.text=="monthly"
      pickup_panda("monthly")
   end
  end
  
      end
      
    else
      visit("https://www.parkingpanda.com/Search/?location=#{city}&monthly=false&daily=true")
      
      sleep 5
	#debugger
      pickup_panda("daily")
    end

    
    rescue Exception => e  
     puts e.message  
     puts e.backtrace.inspect  
    end
  end                                          
#------------------------------------------ pickup
def pickup_panda(desc)
  results =[]
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
      if results[index].present?
        #object.price = item.text
        object = results[index]
        object["price"]= item.text
        #object.save
      end
    end
    results.each do |o|
      item = Result.new
      item.address = o["location"]
      item.location = o["main"]
      item.price = o["price"]
      item.desc=desc
      item.save
    end
end
#-------------------------------------  www.centralparking.com -------------------------------------------------  
                                               
                                               
def get_results_centralpark(params,type)
  begin  
    location = params[:wherebox]
    results=[]
    arr = location.split(",")
    city = arr[0].strip.gsub(" ","-")
    state = arr[1].strip 
    Capybara.run_server = false
    Capybara.current_driver = :webkit
    Capybara.app_host = "https://www.parkingpanda.com"
    if city.downcase =="new-york"
      city_short = "nyc"
    else
      city_short = city.gsub(" ","").gsub("-","") 
    end
    visit("http://#{city_short}.centralparking.com/parking-near/#{city}-#{state}-USA.html")
    list=[]
    all(:css,'.hasCoupon td.itemLabel a').each do |url|
      list << url[:href]
      
    end
    #debugger
    list.each do |url|
      
      visit("http://#{city_short}.centralparking.com#{url}")
      object = Hash.new
      if all(:css,"dl.info dd").size>0
	      object["location"] = all(:css,"dl.info dd").first.text
      end
      if all(:css,"dl.info dd").size>0
	      object["main"] = all(:css,"dl.info dd").first.text
      end
      if type == 'daily'
        if all(:css, "table.layout-table-1 tr td").size>3
	        object["price"] = all(:css, "table.layout-table-1 tr td")[3].text
        end
      else
        if all(:css, "div.monthly-parking-rates p").size>0
         object["price"] = all(:css, "div.monthly-parking-rates p")[0].text
        end
      end
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
    rescue Exception => e  
     puts e.message  
     puts e.backtrace.inspect  
    end
end

  
  
#---------------------------------------------------------------------------------------------------------------  
  def self.search(params)
   agent = Mechanize.new
  page = agent.get("https://www.parkingpanda.com/Search/?location=Miami&start=2/11/2013#location=Miami%2C%20FL%2C%20USA&start=2/11/2013&monthly=false&daily=true")
 
 end
end
