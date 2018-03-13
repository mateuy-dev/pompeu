module Pompeu
  class Translation
    attr_accessor :language, :text, :confidence
    def initialize(language, text, confidence)
      @language = language
      @text = text
      @confidence = confidence
    end
  end
end