require 'test_helper'

class AndroidSourceTest < Minitest::Test
  def setup
    # @target = "android"
    # @key = "some_key"
    # @lang = "en"
    # @text = "some text"
    # @confidence = 5
    # @translatable = true
    #
    # @lang2 = "en"
    # @text2 = "other text"
    # @greater_confidence = 10
    # @less_confidence = 1
    # @@text_db = Pompeu::TextDB.new
    # @text_db.add_translation @target, @key, @lang, @text, @confidence, @translatable
    #
    #

    @languages = ["en", "ca", "fr"]
    @android_path = "test/data/"
    @target = Pompeu::AndroidSource::TARGET
  end

  def test_android_source_import
    @text_db = Pompeu::TextDB.new
    android_source = Pompeu::AndroidSource.new @text_db, @languages, @android_path
    android_source.import

    assert @text_db.find_text @target,"app_name"

    assert_equal "Pompeu", translation("app_name", "en").text
    assert @text_db.find_text(@target,"app_name").translatable

    assert_equal "Do not translate me", translation("no_translate_text", "en").text
    assert !@text_db.find_text(@target,"no_translate_text").translatable

    assert_equal "%d is a parameter", translation("param_text", "en").text
    assert_equal "%1$s is a parameter too", translation("number_param_text", "en").text
    assert_equal "It's a difficult char", translation("characters_1", "en").text
  end

  def translation key, language
    @text_db.find_text(@target,key).translation(language)
  end

  def test_android_source_import_and_export
    @text_db = Pompeu::TextDB.new
    android_source = Pompeu::AndroidSource.new @text_db, @languages, @android_path
    android_source.import
    exported_xml = android_source.create_xml "en"

    pompeu = Pompeu::Pompeu.new("test/data/project_configuration.yml")
    androidFile = Pompeu::AndroidFile.new
    androidFile.load_file"data/values/strings.xml"
    androidFile2 = Pompeu::AndroidFile.new
    androidFile2.load_file "test_data/values/strings.xml"

    assert androidFile.equal? androidFile2

  end


end
