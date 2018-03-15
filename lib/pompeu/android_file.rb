
module Pompeu
  class AndroidFile
    attr_reader :strings
    def initialize(strings = [])
      @strings = strings
    end

    def self.from_xml_file file_path
      File.open(file_path) { |f| from_xml(f) }
    end

    # loads data from strings xml
    def self.from_xml input
      strings = []
      doc = Nokogiri::XML(input)
      string_lines = doc.xpath("//string")
      string_lines.each do |string_line|
        key = string_line["name"]
        translatable = string_line["translatable"]!="false"
        text = string_line.children.text
        strings<<AndroidString.new(key, text, translatable)
      end
      AndroidFile.new strings
    end

    # data to string.xml format
    def to_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
        xml.resources {
          @strings.each do |android_string|
            if android_string.translatable?
              xml.string(name: android_string.key){
                xml.text android_string.text
              }
            else
              xml.string(name: android_string.key, translatable: true){
                xml.text android_string.text
              }
            end
          end
        }
      end
      builder.to_xml(indent: 4)
    end

    def to_text_db textDB, lang
      @strings.each do |android_string|
        textDB.add_translation AndroidSource::TARGET, android_string.key, lang, android_string.text, TranslationConfidence::UNKNOWN, android_string.translatable
      end
    end

    def self.from_text_db textDB, lang
      strings = []
      textDB.texts.each do |pompeu_text|
        translation = pompeu_text.translation(lang)
        if pompeu_text.translation lang
          key = pompeu_text.key_for AndroidSource::TARGET
          text = pompeu_text.translation(lang).text
          translatable = pompeu_text.translatable
          strings << AndroidString.new(key, text, translatable)
        end
      end
      AndroidFile.new strings
    end

    def equal? other
      @strings.sort_by{|x| x.key}.equal? other.strings.sort_by{|x| x.key}
    end
  end
end