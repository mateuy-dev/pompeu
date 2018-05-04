
module Pompeu
  class Gengo
    def export texts, language
      texts.map{|text| line_export(text, language)}.join("\n")
    end

    def line_export text, language
      "[[[#{text.id}]]]\n#{text.translation(language).text}"
    end
  end
end