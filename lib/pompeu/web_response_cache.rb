module Pompeu
  ResponseCacheData = Struct.new :url, :response, :updated_at

  # Stores web responses for later usage
  class WebResponseCache
    def initialize path
      Dir.mkdir path unless File.exist? path
      @path = File.join(path, "web_response_cache.yaml")
      load
    end

    def get url
      cache_response = @cache[url]
      if cache_response
        response = cache_response.response
      else
        puts url
        response = Net::HTTP.get(URI(url))
        add url, response
      end
      response
    end

    private

    def load
      if File.exist? @path
        @cache = File.open(@path) {|file| YAML::load(file)}
      else
        @cache = {}
      end
    end

    def save
      File.open(@path, 'w') do |file|
        YAML.dump(@cache, file)
      end
    end

    def add url, response
      @cache[url] = ResponseCacheData.new(url, response, Time.now)
      save
    end

  end
end