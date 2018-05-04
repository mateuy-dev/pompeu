require 'test_helper'
require 'test_helper_functions'

class RailsSourceTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    prepare_file_tests

    @values_folder = File.join(@tmp_test_data, "rails")

    @target = "rails"
  end

  def teardown
    clear_file_tests
  end

  def test_rails_source_import
    @text_db = Pompeu::TextDB.new
    rails_source = Pompeu::RailsSource.new @text_db, @languages, @values_folder, @target
    rails_source.import

    assert @text_db.find_text @target,["some", "key", "text1"]

    assert_equal "some text", translation(["some", "key", "text1"], "en").text
    assert_equal "another text", translation(["some", "key", "text2"], "en").text
  end


  def test_rails_source_import_and_export
    text_db = Pompeu::TextDB.new
    rails_source = Pompeu::RailsSource.new text_db, @languages, @values_folder, @target
    rails_source.import

    rails_source2 = Pompeu::RailsSource.new text_db, @languages, @outfolder, @target
    rails_source2.export

    assert_empty diff_dirs(@values_folder, @outfolder)


  end

  def translation key, language
    @text_db.find_text(@target,key).translation(language)
  end

end
