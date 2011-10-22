require 'net/http'

module Scrapers
  module Mp
    class Extract
      HOST = "www.parl.gc.ca"
      PATH = "/MembersOfParliament/ProfileMP.aspx"
      QUERY_STRING = "Language=E"

      attr_reader :output_dir

      def initialize(id, options = {})
        @id = id
        @output_dir = options[:output_dir] || File.join(Rails.root, "tmp", "data")
        FileUtils.mkdir_p(@output_dir) if !File.directory?(@output_dir)
      end

      def run
        Net::HTTP.start(HOST) do |http|
          response = http.get(url)
          if response.code == "200"
            File.open(output_file, "w") { |f| f.write(response.body) }
          end
        end
      end

      private

      def output_file
        File.join(Rails.root, "tmp", "data", "mp_#{@id}.html")
      end

      def url
        "#{PATH}?#{QUERY_STRING}&Key=#{@id}"
      end
    end
  end
end
