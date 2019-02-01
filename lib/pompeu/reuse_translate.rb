module Pompeu
  class ReuseTranslate
    include Logging
    attr_accessor :reuse_translator

    def initialize(text_db, languages, default_language)
      @text_db = text_db
      @languages = languages
      @default_language = default_language
      @reuse_translator = ReuseTranslator.new @text_db
    end

    def translate min_quality = TranslationConfidence::PROFESSIONAL_REUSED
      @languages.each do |language|
        lang = language.code
        texts = @text_db.untranslated_or_worse_than lang, @default_language, min_quality
        texts.each do |text|
          translation_text = @reuse_translator.translate(@default_language, text.translation(@default_language).text, lang)
          if translation_text
            translation = translation_text.translation(lang).text
            text.add_translation lang, translation, TranslationConfidence::PROFESSIONAL_REUSED
          end
        end
      end
    end
  end
end