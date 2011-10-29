module Scrapers
  module Members
    class ExtractList < ParliamentExtractor
      HOST = "www.parl.gc.ca"
      PATH = "/MembersOfParliament/MainMPsCompleteList.aspx"
      QUERY_STRING = "TimePeriod=Current&Language=E"

      def output_file
        File.join(@output_dir, "mp_list.html")
      end

      private

      def url
        "#{PATH}?#{QUERY_STRING}"
      end
    end
  end
end
