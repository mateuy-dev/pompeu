module TestHelperFunctions
  require 'fileutils'

  def prepare_file_tests
    @original_test_data = "test/data"
    @tmp_test_data = "test/tmp"
    FileUtils.remove_dir(@tmp_test_data) if File.exist? @tmp_test_data
    Dir.mkdir @tmp_test_data
    FileUtils.copy_entry @original_test_data, @tmp_test_data
    @outfolder = File.join @tmp_test_data, "out"
    Dir.mkdir @outfolder
  end

  def define_test_values
    @skip_internet_test = true

    @target = "android"
    @key = "some_key"
    @lang = "en"
    @text = "Some text"
    @text_ca = "algun text"
    @confidence = 5
    @translatable = true

    @lang2 = "ca"
    @text2 = "other text"
    @greater_confidence = 10
    @less_confidence = 1

    @default_language = "en"
    @languages = Pompeu::Language.load_map({"en" => {"googleplay" => "en-GB"}, "ca" => {}})

    @app_name = "pompeu App"

    @key2 = "another_key"
    @key3 = "yet_another_key"
    @text3 = "lorem ipsum"
  end

  def clear_file_tests
    FileUtils.remove_dir(@tmp_test_data)
  end


  def diff_dirs(dir1, dir2)
    diff_result = `diff -r #{dir1} #{dir2}`
  end

end