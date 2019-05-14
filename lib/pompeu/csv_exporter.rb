module Pompeu
  class CsvExporter
    include Logging

    def import text_db, file, language
      puts "todo"
    end

    def export texts, origin_language, language
      texts.map {|text| line_export(text, origin_language, language)}.join("\n")
    end

    def line_export text, origin_language, language
      [text.id, text.translation(origin_language).text, text.translation(language).text]
    end
  end
end