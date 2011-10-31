module Scrapers
  module Members
    class LoadSummary
      SIMPLE_ATTRIBUTES = [
        "parl_gc_id",
        "parl_gc_constituency_id",
        "name",
        "email",
        "website",
        "parliamentary_phone",
        "parliamentary_fax",
        "preferred_language",
        "constituency_address",
        "constituency_city",
        "constituency_postal_code",
        "constituency_phone",
        "constituency_fax"
      ]

      attr_reader :logger

      def initialize(attributes, options = {})
        @logger = options[:logger] || Rails.logger
        @attributes = attributes
      end

      def run
        mp = Mp.find_or_initialize_by_parl_gc_id( @attributes["parl_gc_id"] )
        mp.attributes = @attributes.slice(*SIMPLE_ATTRIBUTES)

        mp.party = Party.find_by_name_en(@attributes["party"])
        mp.province = Province.find_by_name_en(@attributes["province"])
        mp.riding = Riding.find_by_parl_gc_constituency_id( @attributes["parl_gc_constituency_id"] )

        if mp.save == false
          logger.error "Failed to save MP: #{mp.errors.full_messages}"
        end

        mp
      end
    end
  end
end
