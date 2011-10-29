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
          ids.each do |id|
            extractor = Scrapers::Members::ExtractSummary.new(id)
            extractor.run
            transformer = Scrapers::Members::TransformSummary.new(extractor.output_file)
            loader = Scrapers::Members::LoadSummary.new(transformer.run)
          end
        end
      end
    end
  end
end
