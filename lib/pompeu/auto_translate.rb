module Pompeu
  class AutoTranslate
    include Logging
    attr_accessor :translator, :google_free_translator, :google_original_translator, :google_free_translator_with_python

    def initialize(text_db, languages, default_language, cache = nil, pipcache = nil, api_key: nil)
      @text_db = text_db
      @languages = languages
      @default_language = default_language
      @api_key = api_key

      @google_free_translator = GoogleFreeTranslator.new cache
      @google_original_translator = OfficialGoogleTranslator.new @api_key
      @google_free_translator_with_python = GoogleFreeTranslatorWithPython.new pipcache
      @translator = @google_free_translator_with_python
    end

    def translate min_quality = TranslationConfidence::AUTO
      @languages.each do |language|
        lang = language.code
        texts = @text_db.untranslated_or_worse_than lang, @default_language, min_quality
        texts.each do |text|
          translation = translate_text(text, lang)
          text.add_translation lang, translation, TranslationConfidence::AUTO if translation
        end
      end
    end

    def translate_text text, lang
      if text.translatable
        logger.info "Pompeu - auto translate: #{text.id} #{lang}"
        if !text.translation("en")
          logger.info "Pompeu - auto translate: #{text.id} #{lang}"
        end
        if text.translation(@default_language)
          return @translator.translate(@default_language, text.translation(@default_language).text, lang)
        else
          logger.warn "Pompeu - auto translate: Text not found in default language #{text.id} #{@default_language}"
          return nil;
        end
      end
    end
  end
end