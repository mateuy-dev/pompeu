
module Pompeu
  class OfficialGoogleTranslator
    def initialize pompeu
      require 'easy_translate'
      EasyTranslate.api_key = pompeu.project_configuration["google_api_key"]
    end

    def translate origin_lang, text, end_lang
      subs = "<span class=\"notranslate\">%1$s</span>"
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