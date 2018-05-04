require 'test_helper'
require 'test_helper_functions'


class RailsFileTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values

    @text_db = Pompeu::TextDB.new
    @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
  end

  def test_general
    texts = @text_db.untranslated_or_worse_than "nl", @default_language, @confidence, @target
    result = Pompeu::Gengo.new.export texts, @lang

    assert_equal "[[[android__some_key]]]\nsome text", result
  end



  end
