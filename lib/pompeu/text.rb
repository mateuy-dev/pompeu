module Pompeu
  class Text
    include Logging
    attr_accessor :key, :languages, :translatable
    def initialize key, translatable
      @key = key
      @translatable = translatable
      @languages = {}
    end
    def add lang, text, confidence
      if !@languages[lang]
        logger.info "Pompeu - adding translation: #{key} #{lang} #{text}"
        @languages[lang] = Translation.new lang, text, confidence
      else
        if @languages[lang].confidence > confidence
          raise "Decrease confidence is not allowed"
        elsif @languages[lang].confidence == confidence and (@languages[lang].text != text)
          logger.info "Pompeu - updating translation: #{key} #{lang} #{text}"
        elsif @languages[lang].confidence > confidence
          logger.info "Pompeu - improving translation: #{key} #{lang} #{text}"
        else
          # Nothing done
        end
        @languages[lang].confidence = confidence
        @languages[lang].text = text
      end
    end
    def text_in lang
      @languages[lang]
    end
    def to_xml lang, xml
      if text_in(lang)
        if @translatable
          xml.string(name: @key){
            xml.text text_in(lang).text
          }
        else
          xml.string(name: @key, translatable: @translatable){
            xml.text text_in(lang).text
          }
        end
      end
    end
  end
end