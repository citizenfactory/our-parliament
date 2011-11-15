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
        riding = Riding.find_or_initialize_by_id( @attributes["electoral_district"] )

        riding.attributes = @attributes.slice(*SIMPLE_ATTRIBUTES)
        riding.province = Province.find_by_name_en(@attributes["province"])

        if riding.save == false
          @logger.error "Failed to save riding: #{riding.errors.full_messages}"
        end

        riding
      end
    end
  end
end
