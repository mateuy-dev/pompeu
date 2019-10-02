require 'test_helper'
require 'test_helper_functions'

class GooglePlaySourceTest < Minitest::Test
  include TestHelperFunctions

  def setup
    prepare_file_tests
    define_test_values

    @play_folder = File.join(@tmp_test_data, "play")
    @target = Pompeu::GooglePlayData::TARGET
  end

  def teardown
    clear_file_tests
  end

  def test_google_play_source_import
    @text_db = Pompeu::TextDB.new
    google_play_source = Pompeu::GooglePlaySource.new @text_db, @languages, @play_folder
    google_play_source.import_all


    assert_equal "This is a full description", translation("fulldescription", @lang).text
    assert_equal "This is a short description", translation("shortdescription", @lang).text
    assert_equal "Pompeu", translation("title", @lang).text
    assert_equal "0.1.0\nPompeu testing", translation("whatsnew", @lang).text

  end


  def test_google_play_source_import_and_export
    text_db = Pompeu::TextDB.new
    google_play_source = Pompeu::GooglePlaySource.new text_db, @languages, @play_folder
    google_play_source.import_all

    google_play_source2 = Pompeu::GooglePlaySource.new text_db, @languages, @outfolder
    google_play_source2.export @app_name

    assert_empty diff_dirs(@play_folder, @outfolder)


  end

  def translation key, lang
    @text_db.find_text(@target, key).translation(lang)
  end

end
