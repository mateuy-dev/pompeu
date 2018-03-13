module Pompeu



  class TextDB
    include Logging

    attr_accessor :texts
    def initialize
      @texts = {}
    end

    def add key, lang, text, confidence: TranslationConfidence::UNKNOWN, translatable: true
      if !@texts[key]
        logger.info "Pompeu - adding key: #{key}"
        @texts[key] = Text.new key, translatable
      end
      @texts[key].add lang, text, confidence
    end

    def to_xml lang, xml
      xml.resources {
        @texts.each{|key, text| text.to_xml lang, xml}
      }
    end

  end
end