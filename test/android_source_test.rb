require 'test_helper'
require 'test_helper_functions'

class AndroidSourceTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    prepare_file_tests

    @values_folder = File.join(@tmp_test_data, "android_resources")

    @target = "android"
  end

  def teardown
    clear_file_tests
  end

  def test_android_source_import
    @text_db = Pompeu::TextDB.new
    android_source = Pompeu::AndroidSource.new @text_db, @languages, @default_language, @values_folder, @target
    android_source.import

    assert @text_db.find_text @target, "app_name"

    assert_equal "Pompeu", translation("app_name", "en").text
    assert @text_db.find_text(@target, "app_name").translatable

    assert_equal "Do not translate me", translation("no_translate_text", "en").text
    assert !@text_db.find_text(@target, "no_translate_text").translatable

    assert_equal "%d is a parameter", translation("param_text", "en").text
    assert_equal "%1$s is a parameter too", translation("number_param_text", "en").text
    assert_equal "It's a difficult char", translation("characters_1", "en").text
  end


  def test_android_source_import_and_export
    text_db = Pompeu::TextDB.new
    android_source = Pompeu::AndroidSource.new text_db, @languages, @default_language, @values_folder, @target
    android_source.import

    android_source2 = Pompeu::AndroidSource.new text_db, @languages, @default_language, @outfolder, @target
    android_source2.export

    assert_empty diff_dirs(@values_folder, @outfolder)


  end

  def translation key, language
    @text_db.find_text(@target, key).translation(language)
  end

end
