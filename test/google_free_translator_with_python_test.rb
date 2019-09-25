require 'test_helper'
require 'test_helper_functions'

class AutoTranslateWithPythonTest < Minitest::Test
  include TestHelperFunctions

  def setup
    define_test_values
  end


  def test_auto_translate_with_text
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "The parameter %1$s is a text", "ca"
    assert_equal "El paràmetre %1$s és un text", translation
  end

  def test_auto_translate_with_digit
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "The parameter %d is a number", "ca"
    assert_equal "El paràmetre %d és un número", translation
  end

  def test_auto_translate_with_rails_param
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "The parameter %{param} is a name", "ca"
    assert_equal "El paràmetre %{param} és un nom", translation
  end

  def test_auto_translate_with_rails_param_numeric
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "There are %{param_int} apples in the tree", "ca"
    assert_equal "Hi ha %{param_int} pomes a l'arbre", translation
  end

  def test_auto_translate_with_rails_html_text
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "This is <b>html</b> text", "ca"
    assert_equal "Aquest és el text html", translation
  end

  def test_auto_translate_with_rails_html_link
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "This is <a href=\"somelink\">link</a> to somewhere", "ca"
    assert_equal "Això és <a href=\"somelink\">enllaç</a> a algun lloc", translation
  end

  def test_auto_translate_with_rails_html_and_param
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "This is <a href=\"somelink\">%{param}</a> to somewhere", "ca"
    assert_equal "Aquest és <a href=\"somelink\">%{param}</a> a algun lloc", translation
  end

  def test_auto_translate_with_rails_html_and_param_2
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "If you don't want to recieve this emails, <a href = \"%{url}\">unsubscrive</a> from our mailing list.", "ca"
    assert_equal "Si no voleu rebre aquest correu electrònic, <a href=\"%{url}\">anul·la la subscripció</a> de la nostra llista de correu.", translation
  end

  def test_auto_translate_with_euro_sign
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "The price is 10€", "ca"
    assert_equal "El preu és de 10€", translation
  end

  def test_auto_translate_with_rails_html_unsupported_tags
    assert_raises do
      Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "<p>not valid html</p>", "ca"
    end
  end

  def test_auto_translate
    translation = Pompeu::GoogleFreeTranslatorWithPython.new.translate "en", "One\nTwo\nThree", "ca"
    assert_equal "Un\nDos\nTres", translation
  end
end
