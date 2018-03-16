
module Pompeu
  GooglePlayDataStrings = Struct.new(:fulldescription, :shortdescription, :title, :whatsnew)
  class GooglePlayData
    TARGET = "google_play"
    FILES = {fulldescription: "listing/fulldescription",
      shortdescription: "listing/shortdescription",
      title: "listing/title",
      whatsnew: "whatsnew"}

    attr_reader :strings
    def initialize(strings)
      @strings = strings
    end

    def self.from_files folder_path
      strings = GooglePlayDataStrings.new
      FILES.each_pair do |attr, file|
        path = File.join(folder_path, file)
        strings[attr] = File.read path
      end
      GooglePlayData.new strings
    end

    def to_files folder_path
      listing_path = File.join(folder_path, "listing")
      Dir.mkdir(listing_path) unless File.exist? listing_path
      FILES.each_pair do |attr, file|
        path = File.join(folder_path, file)
        value = @strings[attr]
        File.write(path, value)
      end
    end

    def to_db text_db, lang
      @strings.each_pair do |attr, value|
        text_db.add_translation TARGET, attr, lang, value, TranslationConfidence::UNKNOWN
      end
    end

    def self.from_db text_db, lang
      strings = GooglePlayDataStrings.new
      strings.each_pair do |attr, value|
        pompeu_text = text_db.find_text(TARGET, attr)
        if pompeu_text.translation lang
          text = pompeu_text.translation(lang).text
          strings[attr] = text
        end
      end
      GooglePlayData.new strings
    end

    def ==(other)
      @strings == other.strings
    end
  end
end