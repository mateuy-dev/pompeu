
module Pompeu
  class CsvImportExport
    def export texts, language
      require 'csv'
      CSV.generate do |csv|
        texts.each {|text| csv << [text.id, text.translation(language).text] }
      end
    end
  end
end