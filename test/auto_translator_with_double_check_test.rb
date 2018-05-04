require 'test_helper'
require 'test_helper_functions'

class AutoTranslateTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    @lang3 = "it"
    @lang4 = "el"

    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang2, @text, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang3, @text, @confidence, @translatable
  end

  def test_same_result
    intranslator = DummyTranslator.new
    translator = Pompeu::AutoTranslatorWithDoubleCheck.new intranslator
    text = @text_db.find_text @target, @key

    text, accuracy = translator.translate [@lang, @lang2, @lang3], text, @lang4

    assert_equal @text, text
    assert_equal 3, accuracy
  end

  def test_different_result
    @text_db.add_translation @target, @key, @lang2, @text2, @confidence, @translatable
    @text_db.add_translation @target, @key, @lang3, @text2, @confidence, @translatable

    intranslator = DummyTranslator.new
    translator = Pompeu::AutoTranslatorWithDoubleCheck.new intranslator
    text = @text_db.find_text @target, @key

    text, accuracy = translator.translate [@lang, @lang2, @lang3], text, @lang4

    assert_equal @text2, text
    assert_equal 2, accuracy
  end


  class DummyTranslator
    def translate origin_lang, text, end_lang
      text
    end
  end

end
