module Scrapers
  module Senators
    class LoadSenator
      SIMPLE_ATTRIBUTES = [
        "nomination_date",
        "retirement_date",
        "appointed_by"
      ]

      def initialize(attributes)
        @logger = Rails.logger
        @attributes = attributes
      end

      def run
        senator = Senator.find_or_initialize_by_name( @attributes["name"] )
        senator.attributes = @attributes.slice(*SIMPLE_ATTRIBUTES)

        senator.party = Party.lookup(@attributes["party"]) if @attributes["party"]
        senator.province = Province.lookup(@attributes["province"]) if @attributes["province"]

        if senator.save == false
          @logger.error "Failed to save senator: #{senator.errors.full_messages}"
        end

        senator
      end
    end
  end
end
