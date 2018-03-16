require 'test_helper'
require 'test_helper_functions'

class AndroidFileTest < Minitest::Test
  include TestHelperFunctions

  def setup
    prepare_file_tests

    @text_db = Pompeu::TextDB.new
    @lang = "en-GB"
    @lang_folder = File.join(@tmp_test_data, "play", @lang)
  end

  def teardown
    FileUtils.remove_dir(@tmp_test_data)
  end

  def test_general
    google_play_data = Pompeu::GooglePlayData.from_files @lang_folder
    google_play_data.to_db @text_db, @lang
    google_play_data2 = Pompeu::GooglePlayData.from_db @text_db, @lang
    google_play_data2.to_files @outfolder

    assert_equal google_play_data, google_play_data2
    assert_empty diff_dirs(@lang_folder.to_s, @outfolder.to_s)
  end



end
