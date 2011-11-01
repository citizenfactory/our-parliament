module Scrapers
  module Ridings
    class LoadRiding
      SIMPLE_ATTRIBUTES = [
        "parl_gc_constituency_id",
        "name_en",
        "name_fr"
      ]

      def initialize(attributes, options = {})
        @logger = options[:logger] || Rails.logger
        @attributes = attributes
      end

      def run
        # This is only for the initial load to not re-create all the ridings with, we will need to remove the find by name_en
        # after the initial load of data
        riding = Riding.find_by_parl_gc_constituency_id( @attributes["parl_gc_constituency_id"] )
        riding ||= Riding.find_or_initialize_by_name_en( @attributes["name_en"] )

        riding.attributes = @attributes.slice(*SIMPLE_ATTRIBUTES)

        if riding.save == false
          @logger.error "Failed to save riding: #{riding.errors.full_messages}"
        end

        riding
      end
    end
  end
end
