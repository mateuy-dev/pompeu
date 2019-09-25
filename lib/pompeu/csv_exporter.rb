module Pompeu
  class CsvExporter
    include Logging

    def import text_db, file, language
      require 'csv'
      data = CSV.read(file)
      data.each do |line|
        id = line[0]
        text = line[1]
        text_db.add_text_translation(id, language, text, TranslationConfidence::MANUAL)
      end
    end

    def export texts, origin_language, language
      require 'csv'
      texts.map {|text| line_export(text, origin_language, language)}.join("")
    end

    def line_export text, origin_language, language
      [text.id, text.translation(origin_language).text, text.translation(language) ? text.translation(language).text : ""].to_csv
    end
  end
end