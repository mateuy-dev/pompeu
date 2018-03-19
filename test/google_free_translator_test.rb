require 'test_helper'
require 'test_helper_functions'

class AutoTranslateTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
  end


  def test_auto_translate_with_digit
    translation = Pompeu::GoogleFreeTranslator.new.translate "en", "The parameter %1$s is a name", "ca"
    assert_equal "El paràmetre %1$s és un text", translation
  end

  def test_auto_translate_with_digit
    translation = Pompeu::GoogleFreeTranslator.new.translate "en", "The parameter %d is a number", "ca"
    assert_equal "El paràmetre %d és un número", translation
  end


  def test_auto_translate
    translation = Pompeu::GoogleFreeTranslator.new.translate "en", "One\nTwo\nThree", "ca"
    assert_equal "Un\nDos\nTres", translation
  end
end
