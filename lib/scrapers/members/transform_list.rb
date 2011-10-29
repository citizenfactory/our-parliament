module Scrapers
  module Members
    class TransformList
      def initialize(filename)
        @filename = filename
        @input = File.read(@filename)
      end

      def run
        doc.search('//table[@id$=_grdCompleteList]/tr:gt(0)').map do |row|
          row.at('td[1]/a').
            try(:[], :href).
            try(:match, /Key=(\d+)/).
            try(:[], 1)
        end.compact
      end

      private

      def doc
        @doc ||= Hpricot(@input)
      end
    end
  end
end
