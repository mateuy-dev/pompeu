
module Pompeu
  TextReplacement = Struct.new :replaced, :replacement
  class GoogleFreeTranslator
    @@android_conversions = {"%1$s"=> "Google", "%2$s"=> "Yahoo", "%d"=> "9898"}
    @@names = ["Microsoft", "Facebook", "Twitter"]
    @@integers = ["9652", "8765", "7352"]
    @@rails_param_regex = "(%{[a-zA-z0-9_]+})"


    def initialize(cache = nil)
      @cache = cache
    end

    def response_from url
      if @cache
        response = @cache.get url
      else
        puts url
        response = Net::HTTP.get(URI(url))
      end
      response
    end

    def translate origin_lang, text, end_lang
      require 'net/http'
      require 'json'
      require 'uri'
      converted_text, applied_android_conversions = convert_params text
      encoded_text = URI::encode(converted_text)
      url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=#{origin_lang}&tl=#{end_lang}&dt=t&q=#{encoded_text}"
      response = response_from url
      lines = JSON.parse(response)[0]
      translated = lines.map{ |line| line[0] }.join('')
      unconver_params translated, applied_android_conversions
    end

    def convert_params text
      result = []
      @@android_conversions.each_pair do |param_text, conversion|
        if text.include? param_text
          if text.include? conversion
            raise "GoogleFreeTranslatorError: Text allready contains conversion #{conversion} - #{text}"
          end
          text = text.sub param_text, conversion
          result << TextReplacement.new(param_text, conversion)
        end
      end

      rails_regex = Regexp.new(@@rails_param_regex)
      name_it = 0
      while text.match rails_regex do
        replaced = text.match(rails_regex)[0]
        if replaced.include? "_int"
          replacement = @@integers[name_it]
        else
          replacement = @@names[name_it]
        end
        name_it += 1
        text = text.sub(replaced, replacement)
        result << TextReplacement.new(replaced, replacement)
      end

      [text, result]
    end

    def unconver_params text, applied_android_conversions
      applied_android_conversions.each do |text_replacement|
        text = text.sub text_replacement.replacement, text_replacement.replaced
      end
      text
    end
  end


end