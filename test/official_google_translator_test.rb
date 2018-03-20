require 'test_helper'
require 'test_helper_functions'

class AutoTranslateTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    @skip_after = Date.new(2018,3,17)
  end

  def skip?
    Date.now > @skip_after
  end

  def test_add_no_translate_for_rails
    result = Pompeu::OfficialGoogleTranslator.add_no_translate "Pre text %{param} post Text"
    assert_equal "Pre text <span class=\"notranslate\">%{param}</span> post Text", result
  end

  def test_auto_translate_with_digit
    return if skip?
    translation = Pompeu::OfficialGoogleTranslator.new.translate "en", "The parameter %1$s is a name", "ca"
    assert_equal "El paràmetre %1$s és un text", translation
  end

  def test_auto_translate_with_digit
    return if skip?
    translation = Pompeu::OfficialGoogleTranslator.new.translate "en", "The parameter %d is a number", "ca"
    assert_equal "El paràmetre %d és un número", translation
  end

  def test_auto_translate_with_rails_param
    return if skip?
    translation = Pompeu::OfficialGoogleTranslator.new.translate "en", "The parameter %{param} is a name", "ca"
    assert_equal "El paràmetre %{param} és un nom", translation
  end

  def test_auto_translate_with_rails_html_text
    return if skip?
    translation = Pompeu::OfficialGoogleTranslator.new.translate "en", "This is <b>html</b> text", "ca"
    assert_equal "Aquest és un text <b>html</b>", translation
  end

  def test_auto_translate
    return if skip?
    translation = Pompeu::OfficialGoogleTranslator.new.translate "en", "One\nTwo\nThree", "ca"
    assert_equal "Un\nDos\nTres", translation
  end
end
