require 'test_helper'
require 'test_helper_functions'

class AutoTranslateTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
    @skip_after = Time.new(2018, 3, 17)
  end

  def skip?
    Time.new > @skip_after
  end

  def test_add_no_translate_for_rails
    text = "Pre text %{param} post Text"
    result = Pompeu::OfficialGoogleTranslator.add_no_translate text
    assert_equal "Pre text <span class=\"notranslate\">%{param}</span> post Text", result

    original = Pompeu::OfficialGoogleTranslator.remove_no_translate result
    assert_equal text, original
  end

  def test_add_no_translate_for_rails_with_3_params
    text = "Pre text %{param} and %{middle_one} and also %{the_last_param} Text"
    result = Pompeu::OfficialGoogleTranslator.add_no_translate text
    assert_equal "Pre text <span class=\"notranslate\">%{param}</span> and <span class=\"notranslate\">%{middle_one}</span> and also <span class=\"notranslate\">%{the_last_param}</span> Text", result

    original = Pompeu::OfficialGoogleTranslator.remove_no_translate result
    assert_equal text, original
  end

  def test_add_no_translate_for_rails_multi_line
    text = "Pre text %{param} post Text\nAnd another %{param2} param"
    result = Pompeu::OfficialGoogleTranslator.add_no_translate text
    assert_equal "Pre text <span class=\"notranslate\">%{param}</span> post Text\nAnd another <span class=\"notranslate\">%{param2}</span> param", result

    original = Pompeu::OfficialGoogleTranslator.remove_no_translate result
    assert_equal text, original
  end

  def test_add_no_translate_for_android_param
    text = "The parameter %1$s is a name"
    result = Pompeu::OfficialGoogleTranslator.add_no_translate text
    assert_equal "The parameter <span class=\"notranslate\">%1$s</span> is a name", result

    original = Pompeu::OfficialGoogleTranslator.remove_no_translate result
    assert_equal text, original
  end

  def test_add_no_translate_for_android_short_param
    text = "El paràmetre %d és un número"
    result = Pompeu::OfficialGoogleTranslator.add_no_translate text
    assert_equal "El paràmetre <span class=\"notranslate\">%d</span> és un número", result

    original = Pompeu::OfficialGoogleTranslator.remove_no_translate result
    assert_equal text, original
  end

  def test_add_no_translate_for_android_with_multi_param
    text = "The parameter %1$s is a param, %2$d also\nAnd %d also"
    result = Pompeu::OfficialGoogleTranslator.add_no_translate text
    assert_equal "The parameter <span class=\"notranslate\">%1$s</span> is a param, <span class=\"notranslate\">%2$d</span> also\nAnd <span class=\"notranslate\">%d</span> also", result

    original = Pompeu::OfficialGoogleTranslator.remove_no_translate result
    assert_equal text, original
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
