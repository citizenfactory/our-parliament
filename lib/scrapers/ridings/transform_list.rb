module Scrapers
  module Ridings
    class TransformList
      def initialize(filename)
        @filename = filename
        @input = File.read(@filename)
      end

      def run
        doc.search('//table[@id$=_grdCompleteList]/tr:gt(0)').map do |row|
          {}.tap do |h|
            parl_gc_constituency_id = row.at('//td[1]/a').
              try(:[], :href).
              try(:match, /Key=(\d+)/).
              try(:[], 1)
            name = row.at('//td[1]/a').try(:inner_html)

            h["parl_gc_constituency_id"] = parl_gc_constituency_id if parl_gc_constituency_id.present?
            if name.present?
              h["name_en"] = name
              h["name_fr"] = name
            end
          end
        end.reject(&:empty?)
      end

      private

      def doc
        @doc ||= Hpricot(@input)
      end
    end
  end
end
