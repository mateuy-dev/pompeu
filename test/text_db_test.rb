require 'test_helper'

class TextDbTest < Minitest::Test
  def setup
    @target = "android"
    @key = "some_key"
    @lang = "en"
    @text = "some text"
    @confidence = 5
    @translatable = true

    @lang2 = "en"
    @text2 = "other text"
    @greater_confidence = 10
    @less_confidence = 1
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

end