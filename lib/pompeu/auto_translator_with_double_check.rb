module Pompeu

  class AutoTranslatorWithDoubleCheck
    def initialize(translator)
      @translator = translator
    end

    def translate text, end_lang
      good_translations = text.good_translations
      translations = good_translations.keys.map do |origin_lang|
        text_in_lang = text.translation(origin_lang).text
        @translator.translate origin_lang, text_in_lang, end_lang
      end

      lower_to_text = translations.inject(Hash.new) {|hash, translation| hash[translation.downcase] = translation; hash}
      text_downcase, times = translations.inject(Hash.new(0)) {|total, e| total[e.downcase] += 1; total}.sort_by {|_k, v| -v}.first
      final_text = lower_to_text[text_downcase]

      return final_text, times
    end

  end


end