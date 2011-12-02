module Scrapers
  class Transformation
    def initialize(filename)
      @filename = filename
      @input = File.read(@filename)
    end

    def run
      raise NotImplementedError
    end

    private

    def doc
      @doc ||= Hpricot(@input)
    end
  end
end
