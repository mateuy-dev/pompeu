module Pompeu


  class Text
    include Logging
    #attr_accessor :id, :keys, :translations, :translatable
    attr_reader :translatable
    def initialize id, translatable
      @id = id
      @translatable = translatable
      @keys = []
      @translations = {}
    end

    def self.generate_id target, key
      "#{target}__#{key}"
    end

    def self.create target, key, translatable
      pompeu_text = new Text.generate_id(target, key), translatable
      pompeu_text.add_key target, key
      pompeu_text
    end

    def matches_key? target, key
      text_key = TextKey.new target, key
      @keys.include? text_key
    end

    def key_for target
      @keys.find{ |key| key.target==target }.key
    end

    def add_key target, key
      if !matches_key? target, key
        @keys << TextKey.new(target, key)
      end
    end

    def add_translation lang, text, confidence
      if !@translations[lang]
        logger.info "Pompeu - adding translation: #{@id} #{lang} #{text}"
        @translations[lang] = Translation.new lang, text, confidence
      else
        if @translations[lang].confidence > confidence
          raise "Decrease confidence is not allowed"
        elsif @translations[lang].confidence == confidence and (@translations[lang].text != text)
          logger.info "Pompeu - updating translation: #{@id} #{lang} #{text}"
        elsif @translations[lang].confidence > confidence
          logger.info "Pompeu - improving translation: #{@id} #{lang} #{text}"
        else
          # Nothing done
        end
        @translations[lang].confidence = confidence
        @translations[lang].text = text
      end
    end

    def translation lang
      @translations[lang]
    end

  end

end