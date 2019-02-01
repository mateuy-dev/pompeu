require 'test_helper'
require 'test_helper_functions'

class ReuseTranslateTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
  end

  def test_reuse_translate
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang2, @text2, Pompeu::TranslationConfidence::PROFESSIONAL, @translatable
    @text_db.add_translation @target, @key2, @lang, @text, @confidence, @translatable

    auto_translate = Pompeu::ReuseTranslate.new @text_db, @languages, @default_language
    auto_translate.translate

    assert @text_db.find_text @target, @key2
    assert_equal @text2, translation(@key2, @lang2).text
  end

  def test_reuse_translate_to_improve_auto
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang2, @text2, Pompeu::TranslationConfidence::PROFESSIONAL, @translatable
    @text_db.add_translation @target, @key2, @lang, @text, @confidence, @translatable
    @text_db.add_translation @target, @key2, @lang2, @text3, Pompeu::TranslationConfidence::AUTO_2CHECK, @translatable

    auto_translate = Pompeu::ReuseTranslate.new @text_db, @languages, @default_language
    auto_translate.translate

    assert @text_db.find_text @target, @key2
    assert_equal @text2, translation(@key2, @lang2).text
  end

  def test_reuse_translate_for_updated_text
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang2, @text2, Pompeu::TranslationConfidence::PROFESSIONAL, @translatable
    @text_db.add_translation @target, @key2, @lang, @text3, @confidence, @translatable
    @text_db.add_translation @target, @key2, @lang2, @text3, Pompeu::TranslationConfidence::PROFESSIONAL_REUSED, @translatable

    # update original
    @text_db.add_translation @target, @key2, @lang, @text, @confidence, @translatable

    auto_translate = Pompeu::ReuseTranslate.new @text_db, @languages, @default_language
    auto_translate.translate

    assert @text_db.find_text @target, @key2
    assert_equal @text2, translation(@key2, @lang2).text
  end

  def test_reuse_translate_when_no_translation_found_does_nothing
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
    @text_db.add_translation @target, @key2, @lang, @text, @confidence, @translatable

    auto_translate = Pompeu::ReuseTranslate.new @text_db, @languages, @default_language
    auto_translate.translate

    assert @text_db.find_text @target, @key2
    assert_nil translation(@key2, @lang2)
  end

  def translation key, language
    @text_db.find_text(@target, key).translation(language)
  end

end
