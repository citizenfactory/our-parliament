module Scrapers
  module Members
    class Scrape
      class << self
        def member_list
          extractor = Scrapers::Members::ExtractList.new(extractor_options)
          extractor.run

          transformer = Scrapers::Members::TransformList.new(extractor.output_file)
          transformer.run
        end

        def members(ids, output = $stdout)
          count = 1
          ids.each do |id|
            output.puts "#{count} of #{ids.length} - MP #{id}"

            extractor = Scrapers::Members::ExtractSummary.new(id, extractor_options)
            extractor.run

            transformer = Scrapers::Members::TransformSummary.new(extractor.output_file)

            loader = Scrapers::Members::LoadSummary.new(transformer.run)
            mp = loader.run

            if mp.errors.present?
              output.puts mp.errors.full_messages
            end

            count += 1
          end
        end

        def disable_inactive_members(output = $stdout)
          members = member_list
          conditions = ["parl_gc_id NOT IN (?)", members]

          total = Mp.count
          to_update = Mp.count(:conditions => conditions)

          output.puts "Updating #{to_update} of #{total} MPs"

          if( (to_update.to_f / total) > 0.3 && !force? )
            output.puts "Over 30% of the MPs are changing, I will not update automatically"
          else
            Mp.update_all( {:active => false}, conditions )
          end
        end

        def force?
          ENV['FORCE'] == 'true'
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
