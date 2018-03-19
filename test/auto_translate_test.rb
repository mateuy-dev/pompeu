require 'test_helper'
require 'test_helper_functions'

class AutoTranslateTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
  end


  def test_auto_translate
    return if @skip_internet_test
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable

    auto_translate = Pompeu::AutoTranslate.new @text_db, @languages, @default_language, nil
    auto_translate.translate

    assert @text_db.find_text @target,@key
    assert_equal @text_ca, translation(@key, "ca").text
  end

  def test_auto_translate_for_two_line_text
    return if @skip_internet_test
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, "One\nTwo\nThree", @confidence, @translatable

    auto_translate = Pompeu::AutoTranslate.new @text_db, @languages, @default_language, nil
    auto_translate.translate

    assert @text_db.find_text @target,@key
    assert_equal "Un\nDos\nTres", translation(@key, "ca").text
  end


  def test_auto_translate_with_dummy_translator
    translator = DummyTranslator.new

    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable

    auto_translate = Pompeu::AutoTranslate.new @text_db, @languages, @default_language, nil
    auto_translate.translator = translator
    auto_translate.translate

    assert @text_db.find_text @target,@key
    assert_equal @text, translation(@key, "ca").text
  end

  def translation key, language
    @text_db.find_text(@target,key).translation(language)
  end

  class DummyTranslator
    def translate origin_lang, text, end_lang
      text
    end
  end

end
