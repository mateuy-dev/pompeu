require "pompeu"

module Pompeu
  class RailsConfigCreator
    def self.translate
      google_free_translator = GoogleFreeTranslator.new
      languages = {"sq" => "Albanian", "am" => "Amharic", "ar" => "Arabic", "hy" => "Armenian", "az" => "Azeerbaijani", "be" => "Belarusian", "bn" => "Bengali", "bs" => "Bosnian", "bg" => "Bulgarian", "ca" => "Catalan", "ceb" => "Cebuano", "zh-CN" => "Chinese (Simplified)", "zh-TW" => "Chinese (Traditional)", "hr" => "Croatian", "cs" => "Czech", "da" => "Danish", "nl" => "Dutch", "en" => "English", "et" => "Estonian", "fi" => "Finnish", "fr" => "French", "fy" => "Frisian", "ka" => "Georgian", "el" => "Greek", "gu" => "Gujarati", "ht" => "Haitian Creole", "ha" => "Hausa", "iw" => "Hebrew", "hi" => "Hindi", "hmn" => "Hmong", "hu" => "Hungarian", "is" => "Icelandic", "ig" => "Igbo", "id" => "Indonesian", "it" => "Italian", "ja" => "Japanese", "jw" => "Javanese", "kn" => "Kannada", "kk" => "Kazakh", "km" => "Khmer", "ko" => "Korean", "ku" => "Kurdish", "ky" => "Kyrgyz", "lo" => "Lao", "lv" => "Latvian", "lt" => "Lithuanian", "mk" => "Macedonian", "mg" => "Malagasy", "ms" => "Malay", "ml" => "Malayalam", "mr" => "Marathi", "mn" => "Mongolian", "my" => "Myanmar (Burmese)", "ne" => "Nepali", "no" => "Norwegian", "ny" => "Nyanja", "ps" => "Pashto", "fa" => "Persian", "pl" => "Polish", "pt" => "Portuguese", "pa" => "Punjabi", "ru" => "Russian", "sm" => "Samoan", "sr" => "Serbian", "st" => "Sesotho", "sn" => "Shona", "sd" => "Sindhi", "si" => "Sinhala (Sinhalese)", "sl" => "Slovenian", "so" => "Somali", "es" => "Spanish", "su" => "Sundanese", "sw" => "Swahili", "sv" => "Swedish", "tl" => "Tagalog", "tg" => "Tajik", "ta" => "Tamil", "te" => "Telugu", "th" => "Thai", "tr" => "Turkish", "uk" => "Ukrainian", "ur" => "Urdu", "uz" => "Uzbek", "vi" => "Vietnamese", "xh" => "Xhosa", "yi" => "Yiddish", "yo" => "Yoruba", "zu" => "Zulu"}
      translated_languages = {}
      languages.each_pair do |lang, name|
        translated = google_free_translator.translate "en", name, lang
        translated_languages[lang] = translated
      end

      translated_languages.each_pair do |lang, name|
        puts "<a href=\"/#{lang}\"> #{name}</a>,"
      end
    end
  end
end

#Pompeu::RailsConfigCreator.translate