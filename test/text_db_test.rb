require 'test_helper'
require 'test_helper_functions'

class TextDbTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
  end


  def test_add_translation
    pompeu_text = @text_db.find_text @target, @key
    translation = pompeu_text.translation @lang
    assert pompeu_text.matches_key? @target, @key
    assert @text, translation.text
  end

  def test_add_translation_for_existing_key_new_lang
    @text_db.add_translation @target, @key, @lang2, @text2, @confidence, @translatable

    pompeu_text = @text_db.find_text @target, @key
    assert pompeu_text.matches_key? @target, @key
    assert @text, pompeu_text.translation(@lang)
    assert @text2, pompeu_text.translation(@lang2)
  end

  def test_untranslated_or_worse_than_for_untranslated
    result = @text_db.untranslated_or_worse_than "nl"

    assert_equal 1, result.size
    text = result[0]
    assert @text, text.translation(@lang)
  end

  def test_untranslated_or_worse_than_for_worse_confidence
    result = @text_db.untranslated_or_worse_than "en", @confidence+1

    assert_equal 1, result.size
    text = result[0]
    assert @text, text.translation(@lang)
  end

  def test_untranslated_or_worse_than_for_same_confidence
    result = @text_db.untranslated_or_worse_than @lang, @confidence

    assert_equal 0, result.size
  end

end