module Scrapers
  class Load
    attr_reader :logger

    def initialize(attributes, options = {})
      @logger = options[:logger] || Rails.logger
      @attributes = attributes
    end

    def run
      raise NotImplementedError
    end
  end
end