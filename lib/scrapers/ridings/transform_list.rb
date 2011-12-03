module Scrapers
  module Ridings
    class TransformList < Scrapers::Transform
      def run
        doc.search('//table[@id$=_grdCompleteList]/tr:gt(0)').map do |row|
          row.at('//td[1]/a').
            try(:[], :href).
            try(:match, /Key=(\d+)/).
            try(:[], 1)
        end.compact
      end
    end
  end
end
