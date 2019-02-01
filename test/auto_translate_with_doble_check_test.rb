require 'test_helper'
require 'test_helper_functions'

class AutoTranslateWithDoubleCheckTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    @lang3 = "it"
    @lang4 = "el"

    @origin_langs = [@lang, @lang2, @lang3]

    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang2, @text, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang3, @text, @confidence, @translatable

    @translator = DummyTranslator.new
  end

  def test_auto_translate_dck_mocked_accepted
    auto_translate = Pompeu::AutoTranslateWithDoubleCheck.new @text_db, @lang, @translator
    auto_translate.translate @origin_langs, @lang4, 3, @confidence + 1

    assert @text_db.find_text @target, @key
    assert_equal @text, translation(@key, @lang4).text
  end

  def test_auto_translate_dck_mocked_accepted_confidence_ok
    @text_db.add_translation @target, @key, @lang, @text2, @confidence, @translatable

    auto_translate = Pompeu::AutoTranslateWithDoubleCheck.new @text_db, @lang, @translator
    auto_translate.translate @origin_langs, @lang4, 2, @confidence + 1

    assert @text_db.find_text @target, @key
    assert_equal @text, translation(@key, @lang4).text
  end

  def test_auto_translate_dck_mocked_accepted_confidence_fail
    @text_db.add_translation @target, @key, @lang, @text2, @confidence, @translatable

    auto_translate = Pompeu::AutoTranslateWithDoubleCheck.new @text_db, @lang, @translator
    auto_translate.translate @origin_langs, @lang4, 3, @confidence + 1

    assert @text_db.find_text @target, @key
    assert_nil translation(@key, @lang4)
  end

  def test_auto_translate_dck_mocked_accepted_with_different_captions
    @text_db.add_translation @target, @key, @lang2, @text.downcase, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang3, @text.upcase, @confidence, @translatable

    auto_translate = Pompeu::AutoTranslateWithDoubleCheck.new @text_db, @lang, @translator
    auto_translate.translate @origin_langs, @lang4, 3, @confidence + 1

    assert @text_db.find_text @target, @key
    assert_equal @text.upcase, translation(@key, @lang4).text
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
