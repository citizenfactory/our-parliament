module Scrapers
  class Extract
    HOST = "www.parl.gc.ca"
    PATH = ""
    QUERY_STRING = ""

    attr_reader :logger, :output_dir, :stale_at

    def initialize(options = {})
      @logger = options[:logger] || Rails.logger
      @output_dir = options[:output_dir] || File.join(Rails.root, "tmp", "data")
      @stale_at = options[:stale_at] || 6.days.ago
    end

    def run
      prepare_output_dir
      download_file if stale?
    end

    def output_file
      raise NotImplementedError
    end

    def url
      raise NotImplementedError
    end

    def stale?
      File.exist?(output_file) ? (File.mtime(output_file) < stale_at) : true
    end

    private

    def prepare_output_dir
      FileUtils.mkdir_p(output_dir) if !File.directory?(output_dir)
    end

    def download_file
      Net::HTTP.start(HOST) do |http|
        response = http.get(url)
        if response.code == "200"
          File.open(output_file, "w") { |f| f.write(response.body) }
        else
         logger.error "#{response.code} #{response.message}"
        end
      end
    end
  end
end
