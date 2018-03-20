
module Pompeu
  class OfficialGoogleTranslator
    @@android_conversions = ["%1$s", "%2$s", "%d"]
    @@span_open = "<span class=\"notranslate\">"
    @@span_close = "</span>"


    def initialize api_key
      require 'easy_translate'
      EasyTranslate.api_key = api_key
    end

    def self.add_no_translate text
      text.gsub(/%{[a-z0-9_]+}/i, "#{@@span_open}\0#{@@span_close}")
    end

    def self.remove_no_translate text

    end

    def translate origin_lang, text, end_lang
      text =

      param = "%1$s"
      params_present = text.include? param
      if params_present
        text = text.sub param, subs
      end
      translation = EasyTranslate.translate(text, from: origin_lang, to: end_lang)
      if params_present
        translation = translation.sub subs, param
      end
      translation
    end
  end
end