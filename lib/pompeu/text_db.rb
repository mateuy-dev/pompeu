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

    def untranslated_or_worse_than lang, confidence = -1
      result = []
      @texts.each do |text|
        if text.translatable
          if !text.translation lang
            logger.debug "Pompeu - missing translation found: #{text.id} #{lang}"
            result << text
          elsif text.translation(lang).confidence < confidence
            logger.debug "Pompeu - translation to improve found: #{text.id} #{lang}"
            result << text
          end
        end
      end
      result
    end

  end
end