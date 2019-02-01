require 'test_helper'
require 'test_helper_functions'

class AutoTranslateTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
  end

  def test_auto_translate_mocked
    translator = DummyTranslator.new

    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable

    auto_translate = Pompeu::AutoTranslate.new @text_db, @languages, @default_language, nil
    auto_translate.translator = translator
    auto_translate.translate

    assert @text_db.find_text @target, @key
    assert_equal @text, translation(@key, @lang2).text
  end

  def test_auto_translate_mocked_for_updated_text
    translator = DummyTranslator.new

    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang2, @text, Pompeu::TranslationConfidence::AUTO, @translatable
    # update original
    @text_db.add_translation @target, @key, @lang, @text2, @confidence, @translatable

    auto_translate = Pompeu::AutoTranslate.new @text_db, @languages, @default_language, nil
    auto_translate.translator = translator
    auto_translate.translate

    assert @text_db.find_text @target, @key
    assert_equal @text2, translation(@key, @lang2).text
  end

  def test_auto_translate
    return if @skip_internet_test
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable

    auto_translate = Pompeu::AutoTranslate.new @text_db, @languages, @default_language, nil
    auto_translate.translate

    assert @text_db.find_text @target, @key
    assert_equal @text_ca, translation(@key, @lang2).text
  end

  def test_auto_translate_for_two_line_text
    return if @skip_internet_test
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, "One\nTwo\nThree", @confidence, @translatable

    auto_translate = Pompeu::AutoTranslate.new @text_db, @languages, @default_language, nil
    auto_translate.translate

    assert @text_db.find_text @target, @key
    assert_equal "Un\nDos\nTres", translation(@key, @lang2).text
  end

  def test_auto_translate_for_two_line_html_text
    #return if @skip_internet_test
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, "One<br/>Two", @confidence, @translatable

    auto_translate = Pompeu::AutoTranslate.new @text_db, @languages, @default_language, nil
    auto_translate.translate

    assert @text_db.find_text @target, @key
    assert_equal "Un<br/>Dos", translation(@key, @lang2).text
  end

  def translation key, language
    @text_db.find_text(@target, key).translation(language)
  end

  class DummyTranslator
    def translate origin_lang, text, end_lang
      text
    end
  end

end
