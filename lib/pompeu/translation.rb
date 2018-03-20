module Pompeu
  class Translation
    attr_accessor :language, :text, :confidence, :updated_at
    def initialize(language, text, confidence, updated_at)
      @language = language
      @text = text
      @confidence = confidence
      @updated_at = updated_at
    end
  end
end