module Scrapers
  module Senators
    class ExtractList < Scrapers::Extract
      PATH = "/SenatorsMembers/Senate/SenatorsBiography/isenator.asp"
      QUERY_STRING = "Language=E"

      def output_file
        File.join(@output_dir, "senators_list.html")
      end

      def url
        "#{PATH}?#{QUERY_STRING}"
      end
    end
  end
end
