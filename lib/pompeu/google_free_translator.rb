
module Pompeu
  class GoogleFreeTranslator
    def translate origin_lang, text, end_lang
      require 'net/http'
      require 'json'
      require 'uri'
      encoded_text = URI::encode(text)
      url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=#{origin_lang}&tl=#{end_lang}&dt=t&q=#{encoded_text};"
      response = Net::HTTP.get(URI(url))
      result = JSON.parse(response)[0][0][0]
      if result[-1]==";"
        result = result[0..-2]
      end
      result
    end
  end
end