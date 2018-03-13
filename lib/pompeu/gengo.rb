
module Pompeu
  class Gengo
    def export texts, language
      texts.map{|key, text| line_export(key, text, language)}.join("\n")
    end

    def line_export key, text, language
      "[[[#{key}]]]\n#{text.for_lang(language).text}"
    end
  end
end