module Scrapers
  module Mp
    class Load
      SIMPLE_ATTRIBUTES = [
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
        ::Mp.find_or_create_by_parl_gc_id( @attributes.slice(*SIMPLE_ATTRIBUTES) ) do |mp|
          mp.party = Party.find_by_name_en(@attributes["party"])
          mp.province = Province.find_by_name_en(@attributes["province"])

          # Look at http://www.parl.gc.ca/MembersOfParliament/MainConstituenciesCompleteList.aspx?TimePeriod=Current&Language=E
          # for a better way of building the constituency / electoral district / riding list, and split it out into it's own ETL process
          #mp.riding # currently edid
        end
      end
    end
  end
end
