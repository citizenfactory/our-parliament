module Scrapers
  class ParliamentExtractor
    HOST = "www.parl.gc.ca"
    PATH = ""
    QUERY_STRING = ""

    attr_reader :logger, :output_dir

    def initialize(options = {})
      @logger = options[:logger] || Rails.logger
      @output_dir = options[:output_dir] || File.join(Rails.root, "tmp", "data")
    end

    def run
      prepare_output_dir

      Net::HTTP.start(HOST) do |http|
        response = http.get(url)
        if response.code == "200"
          File.open(output_file, "w") { |f| f.write(response.body) }
        else
         logger.error "#{response.code} #{response.message}"
        end
      end
    end

    def output_file
      raise NotImplementedError
    end

    def url
      raise NotImplementedError
    end

    private

    def prepare_output_dir
      FileUtils.mkdir_p(output_dir) if !File.directory?(output_dir)
    end
  end
end
