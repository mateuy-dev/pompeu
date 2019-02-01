module Pompeu
  class ReuseTranslator
    def initialize(text_db)
      @text_db = text_db
    end


    def translate origin_lang, text, end_lang
      found = @text_db.select_by_text(origin_lang, text).select_by_min_confidence(end_lang, TranslationConfidence::PROFESSIONAL)
      found.texts.first
    end
  end
end