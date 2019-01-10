module Pompeu

  # Contains the Databases of translations
  class TextDB
    include Logging

    attr_reader :texts
    def initialize(texts=[])
      @texts = texts
    end

    def find_text target, key
      @texts.find { |text| text.matches_key? target, key }
    end

    def texts_for_target target
      @texts.select { |text| text.matches_target? target}
    end

    def find_text_by_id id
      @texts.find { |text| text.id == id }
    end

    def select_by_text(language, text_to_find)
      TextDB.new @texts.select { |text| (text.translation(language) && text.translation(language).text == text_to_find )}
    end

    def select_by_min_confidence(language, min_confidence)
      values =  @texts.select do |text|
        (text.translation(language)) && (text.translation(language).confidence >= min_confidence)
      end
      TextDB.new values
    end

    # adding a text translation to an existing text
    def add_text_translation id, lang, text, confidence
      pompeu_text = find_text_by_id(id)
      pompeu_text.add_translation lang, text, confidence
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
    def untranslated_or_worse_than lang, default_lang, confidence = -1, target = nil
      seconds_margin = 5
      result = []
      @texts.each do |text|
        if text.translatable && (!target || text.matches_target?(target))
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