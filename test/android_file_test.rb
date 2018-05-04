require 'test_helper'
require 'test_helper_functions'


class AndroidFileTest < Minitest::Test
  include TestHelperFunctions

  def setup
    prepare_file_tests

    @text_db = Pompeu::TextDB.new
    @lang = "en-GB"
    @lang_file = File.join(@tmp_test_data, "android_resources/values/strings.xml")
    @out_file = File.join(@outfolder, "strings.xml")
    @target = "Android"
  end

  def teardown
    clear_file_tests
  end

  def test_general
    android_file = Pompeu::AndroidFile.from_files @lang_file, @target
    android_file.to_db @text_db, @lang
    android_file_2 = Pompeu::AndroidFile.from_db @text_db, @lang, @target
    android_file_2.to_files @out_file

    assert_equal android_file, android_file_2
    assert_empty diff_dirs(@lang_file, @out_file)
  end

  def test_export_with_keys_not_for_android
    @text_db.add_translation "other_target", "some-key", @lang, 0, true
    android_file = Pompeu::AndroidFile.from_db @text_db, @lang, @target
    android_file.to_files @out_file
  end

  end
