require 'pycall/import'
include PyCall::Import


module Pompeu
  class GoogleFreeTranslatorWithPython
    @@android_conversions = {"%1$s" => "Google", "%2$s" => "Yahoo", "%d" => "9898"}
    @@names = ["Microsoft", "Facebook", "Twitter"]
    @@integers = ["9652", "8765", "7352"]
    @@rails_param_regex = "(%{[a-zA-z0-9_]+})"
    @@html_links = "()"


    def initialize(cache = nil)
      @cache = cache
    end

    def py_translate origin_lang, text, end_lang
      pyimport :googletrans
      translator = googletrans.Translator.new
      translation = translator.translate(text, end_lang, origin_lang)
    end

    def translate origin_lang, text, end_lang
      if text.include?("<p>") || text.include?("<li>") || text.include?("<ul>") || text.include?("<br>") || text.include?("</br>")
        raise "Only some html is supported. " + text
      end

      if text.include?("<br/>")
        return splitAndJoinLines origin_lang, text, end_lang
      end
      converted_text, applied_android_conversions = convert_params text, origin_lang, end_lang

      no_html_text = Nokogiri::HTML(converted_text).text

      translation = py_translate origin_lang, no_html_text, end_lang

      translated = translation.text
      result = unconver_params translated, applied_android_conversions

      Logging.logger.info "Pompeu - translating #{text} in #{origin_lang} to #{end_lang}: #{result}"

      result
    end

    def convert_params text, origin_lang, end_lang
      result = []
      name_it = 0

      # android params
      @@android_conversions.each_pair do |param_text, conversion|
        if text.include? param_text
          if text.include? conversion
            raise "GoogleFreeTranslatorError: Text allready contains conversion #{conversion} - #{text}"
          end
          text = text.sub param_text, conversion
          result << TextReplacement.new(param_text, conversion)
        end
      end

      # rails params
      rails_regex = Regexp.new(@@rails_param_regex)
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

      # html links params
      rails_regex = Regexp.new(@@rails_param_regex)
      doc = Nokogiri::HTML.parse(text)
      doc.css('a').each do |html_link|
        full_link_text = html_link.to_s
        inside_original = html_link.text
        inside_translated = translate(origin_lang, inside_original, end_lang)
        replacement = @@names[name_it]
        replaced = full_link_text.sub ">#{inside_original}<", ">#{inside_translated}<"
        # the <a href will be deleted at the last step. A bit dirty but works for now
        text = text.sub(">#{inside_original}<", ">#{replacement}<")
        name_it += 1
        result << TextReplacement.new(replaced, replacement)
      end

      [text, result]
    end

    def unconver_params text, applied_android_conversions
      applied_android_conversions.reverse_each do |text_replacement|
        text = text.sub text_replacement.replacement, text_replacement.replaced
      end
      text
    end

    def splitAndJoinLines origin_lang, text, end_lang
      text.split('<br/>')
          .map {|line| translate(origin_lang, line, end_lang)}
          .join('<br/>')
    end
  end


end