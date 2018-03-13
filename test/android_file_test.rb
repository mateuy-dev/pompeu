require 'test_helper'

class AndroidFileTest < Minitest::Test
  def simple_test
    pompeu = Pompeu::Pompeu.new("test/data/project_configuration.yml")
    androidFile = Pompeu::AndroidFile.new
    androidFile.load_file"data/values/strings.xml"
    androidFile2 = Pompeu::AndroidFile.new
    androidFile2.load_file "test_data/values/strings.xml"

    assert androidFile.equal? androidFile2
  end
end
