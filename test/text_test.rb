require 'test_helper'

class TextTest < Minitest::Test
  def setup
    @target = "android"
    @key = "some_key"
    @lang = "en"
    @text = "some text"
    @confidence = 5
    @trasnlatable = true

    @text2 = "other text"
    @greater_confidence = 10
    @less_confidence = 1
    @pomeu_text = Pompeu::Text.create @target, @key, @trasnlatable
    @pomeu_text.add_translation @lang, @text, @confidence
  end


  def test_id_generation
    id = Pompeu::Text.generate_id @target, @key
    assert_equal "android__some_key", id
  end


  def test_create_text
    assert_equal @text, @pomeu_text.translation(@lang).text
    assert_equal @confidence, @pomeu_text.translation(@lang).confidence
    assert @pomeu_text.matches_key? @target, @key
  end

  def test_add_translation_with_more_confidence_and_text
    @pomeu_text.add_translation @lang, @text2, @greater_confidence
    assert_equal @text2, @pomeu_text.translation(@lang).text
    assert_equal @greater_confidence, @pomeu_text.translation(@lang).confidence
  end

  def test_add_translation_with_more_confidence
    @pomeu_text.add_translation @lang, @text, @greater_confidence
    assert_equal @text, @pomeu_text.translation(@lang).text
    assert_equal @greater_confidence, @pomeu_text.translation(@lang).confidence
  end

  def test_add_translation_with_same_confidence
    @pomeu_text.add_translation @lang, @text2, @confidence
    assert_equal @text2, @pomeu_text.translation(@lang).text
    assert_equal @confidence, @pomeu_text.translation(@lang).confidence
  end

  def test_add_translation_with_unknown_confidence_and_same_text
    @pomeu_text.add_translation @lang, @text, Pompeu::TranslationConfidence::UNKNOWN
    assert_equal @text, @pomeu_text.translation(@lang).text
    assert_equal @confidence, @pomeu_text.translation(@lang).confidence
  end

  def test_add_translation_with_less_confidence_sould_fail
    assert_raises do
      @pomeu_text.add_translation @lang, @text2, @less_confidence
    end
  end


end