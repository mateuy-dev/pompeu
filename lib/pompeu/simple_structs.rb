module Pompeu
  TextKey = Struct.new(:target, :key)
  TranslatedText = Struct.new(:language, :text, :confidence)
end