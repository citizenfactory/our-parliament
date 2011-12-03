require 'net/http'

module Scrapers
  module Members
    class ExtractSummary < Scrapers::Extract
      PATH = "/MembersOfParliament/ProfileMP.aspx"
      QUERY_STRING = "Language=E"

      def initialize(id, options = {})
        super(options)
        @id = id
      end

      def output_file
        File.join(@output_dir, "mp_#{@id}.html")
      end

      def url
        "#{PATH}?#{QUERY_STRING}&Key=#{@id}"
      end
    end
  end
end
