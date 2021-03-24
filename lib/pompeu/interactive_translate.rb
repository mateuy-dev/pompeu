#!/usr/bin/env ruby


require 'highline'


module Pompeu
  class InteractiveTranslate
    def initialize text_db, default_language, auto_translate
      @text_db = text_db
      @default_language = default_language
      @auto_translate = auto_translate
    end

    def translate language
      cli = HighLine.new
      texts = @text_db.untranslated_or_worse_than language, @default_language, TranslationConfidence::UNKNOWN
      texts.each do |text|
        old_text = text.translation(language)
        old = (old_text && old_text.confidence >= TranslationConfidence::UNKNOWN) ? text.translation(language).text : nil
        original = text.translation(@default_language).text
        proposed = @auto_translate.translate_text text, language
        old = nil if proposed == old
        oldOption = old ? " 1)Old: #{old}\n" : ""
        question = "Key: #{text.id}\n #{@default_language}:    #{original}\n\n Auto:  #{proposed}\n#{oldOption}"
        new_translation = nil
        while !new_translation do
          input = cli.ask question
          if input == "1" and old
            new_translation = old
          elsif input != ""
            new_translation = input
          elsif proposed != ""
            new_translation = proposed
          end
        end
        puts new_translation
        text.add_translation language, new_translation, TranslationConfidence::MANUAL, true
      end
    end
  end
end