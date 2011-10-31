module Scrapers
  module Ridings
    class Scrape
      class << self
        def ridings
          extractor = Scrapers::Ridings::ExtractList.new
          extractor.run

          transformer = Scrapers::Ridings::TransformList.new(extractor.output_file)
          ridings = transformer.run

          count = 1
          ridings.each do |attributes|
            puts "#{count} of #{ridings.length} - Riding #{attributes["parl_gc_constituency_id"]}"

            loader = Scrapers::Ridings::LoadRiding.new( attributes )
            riding = loader.run

            if riding.errors.present?
              puts "Error loading riding, check log for details"
            end

            count += 1
          end
        end
      end
    end
  end
end
