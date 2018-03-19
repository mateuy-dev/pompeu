module Pompeu
  class Language
    attr_reader :code
    def initialize code, platforms
      @code = code
      @platforms = platforms
    end

    def self.load_map map
      languages = []
      map.each_pair do |code, platforms|
        languages << Language.new(code, platforms)
      end
      languages
    end

    def for(platform)
      @platforms[platform] || @code
    end

    def to_s
      @code
    end
  end
end