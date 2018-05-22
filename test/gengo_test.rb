require 'test_helper'
require 'test_helper_functions'


class RailsFileTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    prepare_file_tests

    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
  end

  def test_general
    texts = @text_db.untranslated_or_worse_than "nl", @default_language, @confidence, @target
    result = Pompeu::Gengo.new.export texts, @lang

    assert_equal "[[[android__some_key]]]\nsome text", result
  end

  def test_import
    @text_db.clear
    @text_db.add_translation "google_play", "shortdescription", "en", @text, 0, true
    @text_db.add_translation "google_play", "fulldescription", "en", @text, 0, true
    @text_db.add_translation "google_play", "lasttag", "en", @text, 0, true

    file = File.join(@original_test_data, "translations", "en_gengo.txt")
    result = Pompeu::Gengo.new.import @text_db, file, "en"

    shortdescription = @text_db.find_text("google_play", "shortdescription").translation("en")
    fulldescription = @text_db.find_text("google_play", "fulldescription").translation("en")
    lasttag = @text_db.find_text("google_play", "lasttag").translation("en")

    assert_equal "Short description", shortdescription.text
    assert_equal "This is a full description\n\nWith more than one line", fulldescription.text
    assert_equal "Something else", lasttag.text
  end

  end
