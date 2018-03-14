
module Pompeu
  class AutoTranslate
    include Logging

    attr_accessor :pompeu
    def initialize pompeu
      @pompeu = pompeu
    end
    def translate
      google_free_translator = GoogleFreeTranslator.new
      google_original_translator = OfficialGoogleTranslator.new @pompeu
      translator = google_free_translator
      @pompeu.textDB.texts.each do |key, text|
        if text.translatable
          @pompeu.languages.each do |lang|
            if !text.text_in lang
              Logging.logger.info "Pompeu - auto translate: #{key} #{lang}"
              if !text.text_in("en")
                Logging.logger.info "Pompeu - auto translate: #{key} #{lang}"
              end
              translation = translator.translate("en", text.text_in("en").text, lang)
              text.add lang, translation, TranslationConfidence::AUTO
            end
          end
        end
      end
    end
  end
end