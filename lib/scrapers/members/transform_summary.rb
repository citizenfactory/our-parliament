module Scrapers
  module Members
    class TransformSummary
      def initialize(filename)
        @filename = filename
        @input = File.read(@filename)
      end

      def run
        {}.tap do |h|
          h["parl_gc_id"] = parl_gc_id
          h["parl_gc_constituency_id"] = parl_gc_constituency_id
          h["party"] = doc.at('//a[@id$=_hlCaucusWebSite]').try(:inner_text)

          # @TODO: Look into making this cleaner, possibly by using Québec for the english
          # name, like they do on the governments website
          province = doc.at('//*[@id$=_lblProvinceData]').try(:inner_text)

          h["province"] = ActiveSupport::Inflector.transliterate(province).to_s if province
          h["name"] = doc.at('//*[@id$=_lblMPNameData]').try(:inner_text)
          h["email"] = doc.at('//*[@id$=_hlEMail]').try(:inner_text)
          h["website"] = doc.at('//*[@id$=_hlWebSite]').try(:[], :href)

          h["parliamentary_phone"] = doc.at('//*[@id$=_lblTelephoneData]').try(:inner_text)
          h["parliamentary_fax"] = doc.at('//*[@id$=_lblFaxData]').try(:inner_text)
          h["preferred_language"] = doc.at('//*[@id$=_lblPrefLanguageData]').try(:inner_text)

          const_info = doc.search('//*[@id$=_divConstituencyOffices]/table/tr/td')
          if const_info
            h["constituency_address"] = const_info[0].try(:inner_text).try(:gsub, /, *$/, '')
            h["constituency_city"] = const_info[1].try(:inner_text).try(:split, ', ').try(:first)
            h["constituency_postal_code"] = const_info[2].try(:inner_text)
            h["constituency_phone"] = const_info[4].try(:inner_text).try(:gsub, /Telephone: /, '')
            h["constituency_fax"] = const_info[5].try(:inner_text).try(:gsub, /Fax: /, '')
          end
        end
      end

      private

      def doc
        @doc ||= Hpricot(@input)
      end

      def parl_gc_id
        @filename.slice(/mp_(\d+).html$/, 1)
      end

      def parl_gc_constituency_id
        doc.at('//a[@id$=_hlConstituencyProfile]').
          try(:[], :href).
          try(:match, /Key=(\d+)/).
          try(:[], 1).
          try(:to_i)
      end
    end
  end
end
