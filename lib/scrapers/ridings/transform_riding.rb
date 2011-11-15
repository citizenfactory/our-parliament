module Scrapers
  module Ridings
    class TransformRiding
      def initialize(filename)
        @filename = filename
        @input = File.read(@filename)
      end

      def run
        {}.tap do |h|
          h["electoral_district"] = electoral_district
          h["parl_gc_constituency_id"] = parl_gc_constituency_id

          # @TODO: Look into making this cleaner, possibly by using Québec for the english
          # name, like they do on the governments website
          province = doc.at('//*[@id$=_lblProvinceData]').try(:inner_text)
          h["province"] = ActiveSupport::Inflector.transliterate(province).to_s if province

          h["name_en"] = h["name_fr"] = doc.at('//[@id$=_lblConstituencyNameData]').try(:inner_text)
        end
      end

      private

      def doc
        @doc ||= Hpricot(@input)
      end

      def parl_gc_constituency_id
        @filename.slice(/riding_(\d+).html$/, 1)
      end

      def electoral_district
        id = doc.at('//[@id$=_hlElectionsCanadaProfile]').
               try(:[], :href).
               try(:match, /ED=(\d+)/).
               try(:[], 1)

        id ? id.to_i : nil
      end
    end
  end
end
