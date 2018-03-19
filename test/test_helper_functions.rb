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

  def clear_file_tests
    FileUtils.remove_dir(@tmp_test_data)
  end


  def diff_dirs(dir1, dir2)
    diff_result = `diff -qr #{dir1} #{dir2}`
  end

end