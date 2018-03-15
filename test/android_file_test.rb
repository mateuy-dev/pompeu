require 'test_helper'

class AndroidFileTest < Minitest::Test
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

  def test_general
    android_file = Pompeu::AndroidFile.from_xml_file "test/data/values/strings.xml"
    android_file.to_text_db @text_db, "en"
    android_file_2 = Pompeu::AndroidFile.from_text_db @text_db, "en"

    assert android_file.equal? android_file_2
  end
end
