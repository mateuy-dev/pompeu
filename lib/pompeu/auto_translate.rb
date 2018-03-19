
module Pompeu
  class AutoTranslate
    include Logging

    def initialize text_db, languages, default_language, api_key=nil
      @text_db = text_db
      @languages = languages
      @default_language = default_language
      @api_key = api_key
    end
    def translate
      google_free_translator = GoogleFreeTranslator.new
      google_original_translator = OfficialGoogleTranslator.new @api_key
      translator = google_free_translator
      @text_db.texts.each do |text|
        if text.translatable
          @languages.keys.each do |lang|
            if !text.translation lang
              logger.info "Pompeu - auto translate: #{text.id} #{lang}"
              if !text.translation("en")
                logger.info "Pompeu - auto translate: #{text.id} #{lang}"
              end
              translation = translator.translate(@default_language, text.translation(@default_language).text, lang)
              text.add_translation lang, translation, TranslationConfidence::AUTO
            end
          end
        end
      end
    end
  end
end