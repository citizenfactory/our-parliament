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

      def initialize(attributes)
        @attributes = attributes
      end

      def run
        mp = Mp.find_or_initialize_by_parl_gc_id( @attributes["parl_gc_id"] )
        mp.attributes = @attributes.slice(*SIMPLE_ATTRIBUTES)
        mp.party = Party.find_by_name_en(@attributes["party"])
        mp.province = Province.find_by_name_en(@attributes["province"])

        # Look at http://www.parl.gc.ca/MembersOfParliament/MainConstituenciesCompleteList.aspx?TimePeriod=Current&Language=E
        # for a better way of building the constituency / electoral district / riding list, and split it out into it's own ETL process
        #mp.riding # currently edid

        if mp.save == false
          puts "Failed to save MP: #{mp.errors.full_messages}"
        end

        mp
      end
    end
  end
end
