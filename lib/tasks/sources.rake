namespace :sources do
  desc "TODO"
  task :load => :environment do
    sources = ["aboutairportparking", "airportparking", "parkingconnection", "airportparkingreservations", "gottapark", "pandaparking",
                "parkwhiz", "centralparking", "spothero", "justpark"]
    Source.destroy_all
    sources.each do |source|
      Source.create(:name => source )
    end
  end

end
