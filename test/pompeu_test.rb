require 'test_helper'


class PompeuTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pompeu::VERSION
  end

  def test_simple
    pompeu = Pompeu::Pompeu.new("test/data/project_configuration.yml")
    pompeu.import_existing


    # simpler test. does not work due to comments, etc
    #lang = "en"
    #new_xml = pompeu.to_xml(lang)
    #old_xml = File.open(pompeu.android_file lang) { |f| Nokogiri::XML(f).to_xml }
    #assert_equal new_xml, old_xml

    pompeu.languages.each do |lang|
      new_xml = pompeu.to_xml(lang)
      androidfile1 = Pompeu::AndroidFile.new
      androidfile1.load new_xml
      androidfile2 = Pompeu::AndroidFile.new
      androidfile2.load_file pompeu.android_file lang

      assert_equal androidfile1.strings.size, androidfile2.strings.size
      assert_equal androidfile1.strings.keys.sort, androidfile2.strings.keys.sort
      androidfile1.strings.keys.each do |key|
        assert_equal androidfile1.strings[key], androidfile2.strings[key]
        assert_equal androidfile1.strings[key], androidfile2.strings[key]
      end
    end

    

    #
    #
    # old_xml = File.open(pompeu.android_file lang) { |f| Nokogiri::XML(f) }
    # new_xml = Nokogiri::XML(pompeu.to_xml(lang))
    # new_xml.diff(old_xml) do |change,node|
    #   puts "#{change} #{node.to_html}".ljust(30) + node.parent.path
    # end
  end
end
