require 'test_helper'
require 'test_helper_functions'

class AndroidFileTest < Minitest::Test
  include TestHelperFunctions

  def setup
    prepare_file_tests

    @app_name = "Pompeu App"
    @text_db = Pompeu::TextDB.new
    @lang = "en-GB"
    @lang_folder = File.join(@tmp_test_data, "play", @lang)
  end

  def teardown
    clear_file_tests
  end

  def test_general
    google_play_data = Pompeu::GooglePlayData.from_files @lang_folder
    google_play_data.to_db @text_db, @lang
    google_play_data2 = Pompeu::GooglePlayData.from_db @text_db, @lang
    google_play_data2.to_files @outfolder, "@app_name"

    assert_equal google_play_data, google_play_data2
    assert_empty diff_dirs(@lang_folder.to_s, @outfolder.to_s)
  end

  def test_for_long_title
    google_play_data = Pompeu::GooglePlayData.from_files @lang_folder
    google_play_data.to_db @text_db, @lang
    @text_db.add_translation Pompeu::GooglePlayData::TARGET, "title", @lang, "the translation is too long to fit", Pompeu::TranslationConfidence::UNKNOWN
    google_play_data2 = Pompeu::GooglePlayData.from_db @text_db, @lang
    google_play_data2.to_files @outfolder, @app_name

    @text_db_2 = Pompeu::TextDB.new
    google_play_data = Pompeu::GooglePlayData.from_files @outfolder
    google_play_data.to_db @text_db_2, @lang
    stored = @text_db_2.find_text(Pompeu::GooglePlayData::TARGET, "title").translation @lang

    assert_equal @app_name, stored.text
  end


end
