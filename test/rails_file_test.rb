require 'test_helper'
require 'test_helper_functions'


class RailsFileTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    prepare_file_tests

    @text_db = Pompeu::TextDB.new
    @language = @languages[0]
    @lang_file = File.join(@tmp_test_data, "rails/en.yml")
    @out_file = File.join(@outfolder, "en.yml")

    @target = "rails"
  end

  def teardown
    clear_file_tests
  end

  def test_general
    android_file = Pompeu::RailsFile.from_files @lang_file, @language, @target
    android_file.to_db @text_db, @lang
    android_file_2 = Pompeu::RailsFile.from_db @text_db, @lang, @target
    android_file_2.to_files @out_file, @language

    assert_equal android_file, android_file_2
    assert_empty diff_dirs(@lang_file, @out_file)
  end

  def test_export_with_keys_not_for_android
    @text_db.add_translation "other_target", "some-key", @lang, 0, true
    android_file = Pompeu::RailsFile.from_db @text_db, @lang, @target
    android_file.to_files @out_file, @language
  end

  end
