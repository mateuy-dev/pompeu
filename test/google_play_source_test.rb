require 'test_helper'
require 'test_helper_functions'

class GooglePlaySourceTest < Minitest::Test
  include TestHelperFunctions

  def setup
    prepare_file_tests

    @play_folder = File.join(@tmp_test_data, "play")

    @lang = "en-GB"
    @languages = {"en" => {"googleplay"=>"en-GB"}, "ca"=> {"googleplay"=>"ca"}}
    @target = Pompeu::GooglePlayData::TARGET
  end

  def teardown
    clear_file_tests
  end

  def test_google_play_source_import
    @text_db = Pompeu::TextDB.new
    google_play_source = Pompeu::GooglePlaySource.new @text_db, @languages, @play_folder
    google_play_source.import


    assert_equal "This is a full description", translation("fulldescription", @lang).text
    assert_equal "This is a short description", translation("shortdescription", @lang).text
    assert_equal "Pompeu", translation("title", @lang).text
    assert_equal "0.1.0\nPompeu testing", translation("whatsnew", @lang).text

  end


  def test_google_play_source_import_and_export
    text_db = Pompeu::TextDB.new
    google_play_source = Pompeu::GooglePlaySource.new text_db, @languages, @play_folder
    google_play_source.import

    google_play_source2 = Pompeu::GooglePlaySource.new text_db, @languages, @outfolder
    google_play_source2.export

    assert_empty diff_dirs(@play_folder, @outfolder)


  end

  def translation key, language
    @text_db.find_text(@target,key).translation(language)
  end

end
