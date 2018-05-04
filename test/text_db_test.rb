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
    assert_equal @text, translation.text
  end

  def test_add_translation_for_existing_key_new_lang
    @text_db.add_translation @target, @key, @lang2, @text2, @confidence, @translatable

    pompeu_text = @text_db.find_text @target, @key
    assert pompeu_text.matches_key? @target, @key
    assert_equal @text, pompeu_text.translation(@lang).text
    assert_equal @text2, pompeu_text.translation(@lang2).text
  end

  def test_untranslated_or_worse_than_for_untranslated
    result = @text_db.untranslated_or_worse_than "nl", @default_language

    assert_equal 1, result.size
    assert @text, result[0].translation(@lang)
  end

  def test_untranslated_or_worse_than_for_worse_confidence
    result = @text_db.untranslated_or_worse_than "en", @default_language,@confidence+1

    assert_equal 1, result.size
    assert @text, result[0].translation(@lang)
  end

  def test_untranslated_or_worse_than_for_same_confidence
    result = @text_db.untranslated_or_worse_than @lang, @default_language,@confidence

    assert_equal 0, result.size
  end

  def test_untranslated_or_worse_for_updated_data
    # add translation
    @text_db.add_translation @target, @key, @lang2, @text, @confidence, @translatable
    sleep 6
    # update original
    @text_db.add_translation @target, @key, @lang, @text2, @confidence, @translatable

    result = @text_db.untranslated_or_worse_than @lang2, @default_language,@confidence

    assert_equal 1, result.size
    assert @text2, result[0].translation(@lang)
  end

  def test_untranslated_or_worse_for_updated_data_with_more_confidence
    # add translation
    @text_db.add_translation @target, @key, @lang2, @text, @confidence+100, @translatable
    sleep 0.1
    # update original
    @text_db.add_translation @target, @key, @lang, @text2, @confidence, @translatable

    result = @text_db.untranslated_or_worse_than @lang2, @default_language,@confidence

    assert_equal 0, result.size
  end

  def test_untranslated_or_worse_for_specific_target
    result = @text_db.untranslated_or_worse_than "nl", @default_language, @confidence, @target

    assert_equal 1, result.size
    assert @text, result[0].translation(@lang)
  end

  def test_untranslated_or_worse_for_specific_unexisting_target
    result = @text_db.untranslated_or_worse_than "nl", @default_language, @confidence, "another_target"

    assert_equal 0, result.size
  end

  # def test_temporal
  #   @text_db.add_translation Pompeu::RailsFile::TARGET, ["some","key_html"], @lang, @text, @confidence,@translatable
  #   @text_db.add_translation Pompeu::RailsFile::TARGET, ["some","key_html"], @lang2, @text, @confidence, @translatable
  #
  #   result = @text_db.untranslated_or_worse_than @lang2, @default_language,@confidence
  #
  #   assert_equal 2, result.size
  # end

end