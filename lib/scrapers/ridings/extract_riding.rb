module Scrapers
  module Ridings
    class ExtractRiding < Scrapers::ParliamentExtractor
      PATH = "/MembersOfParliament/ProfileConstituency.aspx"
      QUERY_STRING = "Language=E"

      def initialize(id, options = {})
        super(options)
        @id = id
      end

      def output_file
        File.join(@output_dir, "riding_#{@id}.html")
      end

      def url
        "#{PATH}?#{QUERY_STRING}&Key=#{@id}"
      end
    end
  end
end
