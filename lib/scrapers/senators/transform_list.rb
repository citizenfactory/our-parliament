module Scrapers
  module Senators
    class TransformList < Scrapers::Transform
      def run
        doc.search('//html/body/table[2]/tr/td[2]/table/tr').map do |row|
          next if row.to_s !~ /isenator/

          {}.tap do |h|
            h['name'] = clean(row.at('/td[1]/a').try(:inner_html))
            h['party'] = clean(row.at('/td[2]').try(:inner_html))
            h['province'] = province(row.at('/td[3]').try(:inner_html))
            h['nomination_date'] = clean(row.at('/td[4]').try(:inner_html))
            h['retirement_date'] = clean(row.at('/td[5]').try(:inner_html))
            h['appointed_by'] = clean(row.at('/td[6]').try(:inner_html))
          end
        end.compact
      end

      private

      def province(text)
        clean(text).gsub(/\(.*\)$/, '').gsub(/\/.*$/, '').strip if text
      end

      def clean(text)
        # gsub(/\302\240/, ' ') is a non-printed char that Nokogiri lets through
        text.gsub(/&nbsp;/, ' ').gsub(/\302\240/, ' ').gsub(/\s+/, ' ').strip if text
      end
    end
  end
end
