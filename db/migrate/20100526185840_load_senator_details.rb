require 'fastercsv'

class LoadSenatorDetails < ActiveRecord::Migration
  def self.up
    data_file = File.join(RAILS_ROOT, 'open-parliament-data', 'senator_data', 'Senator Details.csv')
    FasterCSV.foreach(data_file, :encoding => 'N', :headers => true, :return_headers => false, :header_converters => :symbol, :converters => :all) do |row|
      senator = Senator.find_by_name(row[:name])
      if senator
        senator.province = row[:province] if row[:province]
        senator.personal_website = row[:personal_website_url] if row[:personal_website_url]
        senator.party_website = row[:party_website_url] if row[:party_website_url]
        senator.save
      end
    end
  end

  def self.down
     Senator.delete_all
  end
end
