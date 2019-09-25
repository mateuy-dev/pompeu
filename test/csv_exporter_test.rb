require 'test_helper'
require 'test_helper_functions'


class CsvExrpoterTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    prepare_file_tests

    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
  end

  def test_export
    @text_db.add_translation @target, @key, "sk", @text2, @confidence, @translatable
    texts = @text_db.untranslated_or_worse_than "sk", @default_language, Pompeu::TranslationConfidence::PROFESSIONAL, @target
    result = Pompeu::CsvExporter.new.export texts, @lang, "sk"

    assert_equal "android__some_key,Some text,other text\n", result
  end

  def test_import
    @text_db.clear
    @text_db.add_translation "android", "action_settings", "sk", @text, 0, true
    @text_db.add_translation "android", "vaca_detail_activity", "sk", @text, 0, true

    file = File.join(@original_test_data, "translations", "sk_exported.csv")
    result = Pompeu::CsvExporter.new.import @text_db, file, "sk"

    text1 = @text_db.find_text("android", "action_settings").translation("sk")
    text2 = @text_db.find_text("android", "vaca_detail_activity").translation("sk")

    assert_equal "Nastavenia", text1.text
    assert_equal "Krava", text2.text
  end

end
