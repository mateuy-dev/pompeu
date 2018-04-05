module Pompeu

  class TextDB
    include Logging

    attr_reader :texts
    def initialize
      @texts = []
    end

    def find_text target, key
      @texts.find { |text| text.matches_key? target, key }
    end

    def texts_for_target target
      @texts.select { |text| text.matches_target? target}
    end


    # def add key, lang, text, confidence: TranslationConfidence::UNKNOWN, translatable: true
    def add_translation target, key, lang, text, confidence, translatable = true
      pompeu_text = find_text(target, key)
      if !pompeu_text
        logger.info "Pompeu - adding key: #{target} #{key}"
        pompeu_text = Text.create target, key, translatable
        @texts << pompeu_text
      end
      pompeu_text.add_translation lang, text, confidence
    end

    def clear
      @text = []
    end

    # Returns the untranslated texts, the translated with less confidence than the given,
    # or the translated with same confidence but that are older than the default language
    def untranslated_or_worse_than lang, default_lang, confidence = -1
      seconds_margin = 5
      result = []
      @texts.each do |text|
        if text.translatable
          translation = text.translation(lang)
          if !text.translation(default_lang)
            logger.debug "Pompeu - original text for : #{text.id}"
          elsif !translation
            logger.debug "Pompeu - missing translation found: #{text.id} #{lang}"
            result << text
          elsif translation.confidence < confidence
            logger.debug "Pompeu - translation to improve found: #{text.id} #{lang}"
            result << text
          elsif translation.confidence == confidence and (translation.updated_at + seconds_margin) < text.translation(default_lang).updated_at
            logger.debug "Pompeu - translation to update: #{text.id} #{lang}"
            result << text
          #elsif translation.confidence == confidence and text.matches_target?(RailsFile::TARGET) and text.key_for(RailsFile::TARGET)[-1].end_with? "_html"
          #  logger.debug "Pompeu - translation to update: #{text.id} #{lang}"
          #  result << text
          end
        end
      end
      result
    end

  end
end