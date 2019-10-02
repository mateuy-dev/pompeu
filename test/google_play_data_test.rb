require 'test_helper'
require 'test_helper_functions'

class AndroidFileTest < Minitest::Test
  include TestHelperFunctions

  def setup
    prepare_file_tests
    define_test_values

    @app_name = "Pompeu App"
    @text_db = Pompeu::TextDB.new
    @language = @languages[0]
    @lang = @language.code

    @play_folder = File.join(@tmp_test_data, "play")
  end

  def teardown
    clear_file_tests
  end

  def test_general
    @languages.each do |language|
      google_play_data = Pompeu::GooglePlayData.from_files @play_folder, language
      google_play_data.to_db @text_db
      google_play_data2 = Pompeu::GooglePlayData.from_db @text_db, language
      google_play_data2.to_files @outfolder, "@app_name"

      assert_equal google_play_data, google_play_data2
    end

    assert_empty diff_dirs(@play_folder.to_s, @outfolder.to_s)
  end

  def test_for_long_title
    google_play_data = Pompeu::GooglePlayData.from_files @play_folder, @language
    google_play_data.to_db @text_db
    @text_db.add_translation Pompeu::GooglePlayData::TARGET, "title", @lang, "the translation is too long to fit", Pompeu::TranslationConfidence::UNKNOWN
    google_play_data2 = Pompeu::GooglePlayData.from_db @text_db, @language
    google_play_data2.to_files @outfolder, @app_name

    @text_db_2 = Pompeu::TextDB.new
    google_play_data = Pompeu::GooglePlayData.from_files @outfolder, @language
    google_play_data.to_db @text_db_2
    stored = @text_db_2.find_text(Pompeu::GooglePlayData::TARGET, "title").translation @lang

    assert_equal @app_name, stored.text
  end


end
