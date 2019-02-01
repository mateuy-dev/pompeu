module Pompeu
  class Gengo
    include Logging
    ID_TAG = "textid"

    def import text_db, file, language
      data = File.read file
      text_id = nil
      text = ""
      File.open(file).each do |line|
        if line.start_with? "[[[#{ID_TAG} "
          if text_id
            logger.info "Pompeu - Gengo adding translation: #{text_id} #{language} #{text.strip}"
            text_db.add_text_translation text_id, language, text.strip, TranslationConfidence::PROFESSIONAL
          end
          text_id = line.sub("[[[#{ID_TAG} ", '').sub(']]]', '').strip
          text = ""
        else
          text += line
        end
      end
      text_db.add_text_translation text_id, language, text.strip, TranslationConfidence::PROFESSIONAL
      logger.info "Pompeu - Gengo adding translation: #{text_id} #{language} #{text.strip}"
    end

    def export texts, language
      texts.map {|text| line_export(text, language)}.join("\n")
    end

    def line_export text, language
      "[[[#{ID_TAG} #{text.id}]]]\n#{text.translation(language).text}"
    end
  end
end