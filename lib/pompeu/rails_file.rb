
module Pompeu
  # key is an array of strings
  RailsString = Struct.new(:keys, :text)

  class RailsFile
    TARGET = "RubyOnRails"

    attr_reader :strings
    def initialize(strings = [])
      @strings = strings
    end

    def self.from_files file_path, language
      strings = []
      file = YAML.load_file(file_path)
      hashed_texts = flat_hash(file[language.for("rails")])
      hashed_texts.each_pair do |key, value|
        strings << RailsString.new(key, unescape(value))
      end
      RailsFile.new strings
    end

    def self.flat_hash(hash, k = [])
      return {k => hash} unless hash.is_a?(Hash)
      hash.inject({}){ |h, v| h.merge! flat_hash(v[-1], k + [v[0]]) }
    end


    # data to string.xml format
    def to_map language
      #result = {language.for("rails")=> {}}
      #result = result[language.for("rails")]
      result = {}
      @strings.each do |rails_string|
        current = result
        rails_string.keys[0..-2].each do |key|
          current[key] ||= {}
          current = current[key]
        end
        current[rails_string.keys[-1]] = escape(rails_string.text)
      end
      {language.for("rails")=> result}
    end

    def to_files file, language
      File.write(file, to_map(language).to_yaml)
    end

    def to_db textDB, lang
      @strings.each do |rails_string|
        textDB.add_translation TARGET, rails_string.keys, lang, rails_string.text, TranslationConfidence::UNKNOWN, true
      end
    end

    def self.from_db textDB, lang
      strings = []
      textDB.texts_for_target(TARGET).each do |pompeu_text|
        translation = pompeu_text.translation(lang)
        if pompeu_text.translation lang
          key = pompeu_text.key_for TARGET
          text = pompeu_text.translation(lang).text
          strings << RailsString.new(key, text)
        end
      end
      RailsFile.new strings
    end

    def self.unescape string
      # string.gsub("\\'", "'")
      string
    end

    def escape string
      # string.gsub("'", "\\\\'")
      string
    end

    def ==(other_object)
      @strings.sort_by{|x| x.keys.join(",")} == other_object.strings.sort_by{|x| x.keys.join(",")}
    end
  end
end