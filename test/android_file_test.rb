require 'test_helper'
require 'test_helper_functions'


class AndroidFileTest < Minitest::Test
  include TestHelperFunctions

  def setup
    prepare_file_tests

    @text_db = Pompeu::TextDB.new
    @lang = "en-GB"
    @lang_file = File.join(@tmp_test_data, "values/strings.xml")
    @out_file = File.join(@outfolder, "strings.xml")
  end

  def test_general
    android_file = Pompeu::AndroidFile.from_files @lang_file
    android_file.to_db @text_db, @lang
    android_file_2 = Pompeu::AndroidFile.from_db @text_db, @lang
    android_file_2.to_files @out_file

    assert_equal android_file, android_file_2
    assert_empty diff_dirs(@lang_file, @out_file)

  end
end
