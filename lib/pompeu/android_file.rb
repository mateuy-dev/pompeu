
module Pompeu
  class AndroidFile
    attr_accessor :strings
    def initialize
    end

    def load_file file_path
      File.open(file_path) { |f| load(f) }
    end
    def load input
      @strings={}
      doc = Nokogiri::XML(input)
      string_lines = doc.xpath("//string")
      string_lines.each do |string_line|
        key = string_line["name"]
        translatable = string_line["translatable"]!="false"
        text = string_line.children.text
        @strings[key] = {text: text, translatable: translatable}
      end
    end

    def equal? other
      (@strings.keys.sort.equal? other.keys.sort) and @strings.reduce(true){|same, (key, value)| same and value.equal?(other[key])}
    end
  end
end