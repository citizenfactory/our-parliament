module Scrapers
  module Ridings
    class ExtractList < Scrapers::Extract
      PATH = "/MembersOfParliament/MainConstituenciesCompleteList.aspx"
      QUERY_STRING = "TimePeriod=Current&Language=E"

      def output_file
        File.join(@output_dir, "ridings_list.html")
      end

      def url
        "#{PATH}?#{QUERY_STRING}"
      end
    end
  end
end
