module Pompeu
  PipCacheData = Struct.new :origin_lang, :text, :end_lang, :translation, :updated_at

  # Stores web responses for later usage
  class PipTranslateCache
    def initialize path
      Dir.mkdir path unless File.exist? path
      @path = File.join(path, "pip_translate_cache.yaml")
      load
    end

    def get origin_lang, text, end_lang
      @cache.dig(origin_lang, end_lang, text)
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

    def add origin_lang, text, end_lang, translation
      @cache[origin_lang] = {} if !@cache[origin_lang]
      @cache[origin_lang][end_lang] = {} if !@cache[origin_lang][end_lang]
      @cache[origin_lang][end_lang][text] = PipCacheData.new(origin_lang, text, end_lang, translation, Time.now)
      save
    end

  end
end