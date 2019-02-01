module Pompeu
  TranslationCacheData = Struct.new :text, :updated_at

  # Stores web responses for later usage
  class TranslateCache
    def initialize path
      Dir.mkdir path unless File.exist? path
      @path = File.join(path, "translate_cache.yaml")
      load
    end

    def get origin_lang, text_origin, end_lang
      @cache[[origin_lang, text_origin, end_lang]].try(:text)
    end

    def add origin_lang, text_origin, end_lang, text_result
      @cache[[text_origin, origin_lang, end_lang]] = text_result, Time.now
      save
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
  end
end