
module Pompeu
  class GoogleFreeTranslator
    @@conversions = {"%1$s"=> "Google", "%d"=> "10"}

    def translate origin_lang, text, end_lang
      require 'net/http'
      require 'json'
      require 'uri'
      converted_text, applied_conversions = convert_params text
      encoded_text = URI::encode(converted_text)
      url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=#{origin_lang}&tl=#{end_lang}&dt=t&q=#{encoded_text}"
      puts url
      response = Net::HTTP.get(URI(url))
      lines = JSON.parse(response)[0]
      translated = lines.map{ |line| line[0] }.join('')

      unconver_params translated, applied_conversions
    end

    def convert_params text
      result = []
      @@conversions.each_pair do |param_text, conversion|
        if text.include? param_text
          text = text.sub param_text, conversion
          result << param_text
        end
      end
      [text, result]
    end
    def unconver_params text, applied_conversions
      applied_conversions.each do |conversion|
        text = text.sub @@conversions[conversion], conversion
      end
      text
    end
  end
end