
module Pompeu

  class AutoTranslatorWithDoubleCheck
    def initialize(translator)
      @translator = translator
    end

    def translate origin_langs, text, end_lang
      translations = origin_langs.map do |origin_lang|
        text_in_lang = text.translation(origin_lang).text
        @translator.translate origin_lang, text_in_lang, end_lang
      end

      text, times = translations.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}.sort_by { |_k, v| -v }.first

      return text, times
    end
  end


end