module Scrapers
  module Members
    class Scrape
      class << self
        def member_list
          extractor = Scrapers::Members::ExtractList.new
          extractor.run

          transformer = Scrapers::Members::TransformList.new(extractor.output_file)
          transformer.run
        end

        def members(ids)
          count = 1
          ids.each do |id|
            puts "#{count} of #{ids.length} - MP #{id}"
            extractor = Scrapers::Members::ExtractSummary.new(id)
            extractor.run
            transformer = Scrapers::Members::TransformSummary.new(extractor.output_file)
            loader = Scrapers::Members::LoadSummary.new(transformer.run)
            mp = loader.run

            if mp.errors.present?
              puts mp.errors.full_messages
            end

            count += 1
          end
        end
      end
    end
  end
end
