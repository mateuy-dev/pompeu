

module Pompeu
  class PompeuExtractor
    attr_accessor :pompeu
    def initialize pompeu
      @pompeu = pompeu
    end

    def untranslated lang
      default_lang = @pompeu.project_configuration["default_lang"]
      texts = {}
      @pompeu.textDB.texts.each do |key, text|
        if text.translatable
          if !text.text_in lang
            logger.debug "Pompeu - missing translation: #{key} #{lang}"
            texts[key] = text.text_in default_lang
          end
        end
      end
      texts
    end

    # Returns a hash key-> Text
    def untranslated_or_worse_than lang, confidence
      texts = {}
      @pompeu.textDB.texts.each do |key, text|
        if text.translatable
          if !text.text_in lang
            logger.debug "Pompeu - missing translation found: #{key} #{lang}"
            texts[key] = text
          elsif text.text_in(lang).confidence < confidence
            logger.debug "Pompeu - translation to improve found: #{key} #{lang}"
            texts[key] = text
          end
        end
      end
      texts
    end
  end
end