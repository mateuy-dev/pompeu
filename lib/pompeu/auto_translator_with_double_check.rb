
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

      lower_to_text = translations.inject(Hash.new) { |hash, translation| hash[translation.downcase] = translation; hash}
      text_downcase, times = translations.inject(Hash.new(0)) { |total, e| total[e.downcase] += 1 ;total}.sort_by { |_k, v| -v }.first
      text = lower_to_text[text_downcase]

      return text, times
    end
  end


end