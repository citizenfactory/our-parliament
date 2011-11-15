module Scrapers
  module Ridings
    class Scrape
      class << self
        def riding_list
          extractor = Scrapers::Ridings::ExtractList.new
          extractor.run

          transformer = Scrapers::Ridings::TransformList.new(extractor.output_file)
          ridings = transformer.run
        end

        def ridings(ids, output = $stdout)
          count = 1
          ids.each do |id|
            output.puts "#{count} of #{ids.length} - Riding #{id}"

            extractor = Scrapers::Ridings::ExtractRiding.new(id, extractor_options)
            extractor.run

            transformer = Scrapers::Ridings::TransformRiding.new(extractor.output_file)

            loader = Scrapers::Ridings::LoadRiding.new( transformer.run )
            riding = loader.run

            if riding.errors.present?
              output.puts "Error loading riding, check log for details"
            end

            count += 1
          end
        end

        def extractor_options
          options = {}
          options[:stale_at] = ENV['STALE_AT'].to_i.days.ago if ENV['STALE_AT']

          options
        end
      end
    end
  end
end
