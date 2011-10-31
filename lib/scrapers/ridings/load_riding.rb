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
        riding = Riding.find_or_initialize_by_parl_gc_constituency_id( @attributes["parl_gc_constituency_id"] )
        riding.attributes = @attributes.slice(*SIMPLE_ATTRIBUTES)

        if riding.save == false
          @logger.error "Failed to save riding: #{riding.errors.full_messages}"
        end

        riding
      end
    end
  end
end
