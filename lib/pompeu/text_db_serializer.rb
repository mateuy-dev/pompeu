module Pompeu
  class TextDbSerializer
    def initialize db_path
      @db_path = db_path
    end

    def load_file
      if File.file? @db_path
        File.open(@db_path) {|file| YAML::load(file)}
      else
        TextDB.new
      end
    end

    def save textDB
      File.open(@db_path, 'w') do |file|
        YAML.dump(textDB, file)
      end
    end

    def clear
      File.delete @db_path if File.exist?(@db_path)
    end
  end
end