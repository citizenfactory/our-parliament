module Scrapers
  module Senators
    class Scrape
      class << self
        def senator_list
          extractor = Scrapers::Senators::ExtractList.new
          extractor.run

          transformer = Scrapers::Senators::TransformList.new(extractor.output_file)
          transformer.run
        end

        def senators(senators, output = $stdout)
          count = 1
          senators.each do |senator|
            output.puts "#{count} of #{senators.length} - Senator #{senator["name"]}"

            loader = Scrapers::Senators::LoadSenator.new(senator)
            senator = loader.run

            if senator.errors.present?
              output.puts senator.errors.full_messages
            end

            count += 1
          end
        end

        def delete_inactive_senators
          senators = senator_list
          Senator.delete_all( ["name NOT IN (?)", senators.map { |senator| senator["name"] }] )
        end
      end
    end
  end
end
