
module Pompeu
  class AutoTranslate
    include Logging
    attr_accessor :translator
    def initialize text_db, languages, default_language, api_key=nil
      @text_db = text_db
      @languages = languages
      @default_language = default_language
      @api_key = api_key

      @google_free_translator = GoogleFreeTranslator.new
      @google_original_translator = OfficialGoogleTranslator.new @api_key
      @translator = @google_free_translator
    end
    def translate min_quality = TranslationConfidence::AUTO
      @languages.each do |language|
        lang = language.code
        texts = @text_db.untranslated_or_worse_than lang, @default_language, min_quality
        texts.each do |text|
          if text.translatable
            logger.info "Pompeu - auto translate: #{text.id} #{lang}"
            if !text.translation("en")
              logger.info "Pompeu - auto translate: #{text.id} #{lang}"
            end
            translation = @translator.translate(@default_language, text.translation(@default_language).text, lang)
            text.add_translation lang, translation, TranslationConfidence::AUTO
          end
        end
      end
    end
  end
end