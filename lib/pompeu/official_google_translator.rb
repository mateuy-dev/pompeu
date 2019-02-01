module Pompeu
  class OfficialGoogleTranslator
    @@android_conversions = ["%1$s", "%2$s", "%d"]
    @@span_open = "<span class=\"notranslate\">"
    @@span_close = "</span>"

    @@rails_param_regex = "(%{[a-zA-z0-9_]+})"
    @@android_regex = "(%([0-9]\\$)?[a-z])"

    def initialize api_key
      require 'easy_translate'
      EasyTranslate.api_key = api_key
    end

    def add_no_translate text
      rails_regex = Regexp.new(@@rails_param_regex)
      text = text.gsub(rails_regex, "#{@@span_open}\\1#{@@span_close}")
      android_regex = Regexp.new(@@android_regex)
      text = text.gsub(android_regex, "#{@@span_open}\\1#{@@span_close}")
    end

    def remove_no_translate text
      rails_regex = Regexp.new("#{@@span_open}#{@@rails_param_regex}#{@@span_close}")
      text = text.gsub(rails_regex, "\\1")
      android_regex = Regexp.new("#{@@span_open}#{@@android_regex}#{@@span_close}")
      text = text.gsub(android_regex, "\\1")
    end

    def translate origin_lang, text, end_lang
      text = add_no_translate text
      translation = EasyTranslate.translate(text, from: origin_lang, to: end_lang)
      if params_present
        translation = translation.sub subs, param
      end
      remove_no_translate text
    end
  end
end