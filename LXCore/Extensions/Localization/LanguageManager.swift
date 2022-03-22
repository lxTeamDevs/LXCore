//
//  LanguageManager.swift
//  FastShift
//
//  Created by Ani  Mkrtchyan on 3/24/21.
//

import Foundation

class LanguageManager {
    enum Language: String {
        case english = "en"
        case armenian = "hy"
        case russian = "ru"
        
        var title: String? {
            switch self {
            case .russian:
                return "languages.russian".localized
            case .english:
                return "languages.english".localized
            case .armenian:
                return "languages.armenian".localized
            }
        }
    }
    
    static let shared = LanguageManager()
    
    func initialize() {
        setLanguage(current)
    }

    var current: Language {
        if let lang = Language(rawValue: UserDefaults.standard.string(forKey: "_language") ?? "") {
            return lang
        }
        return .armenian
    }
    
    var locale: Locale {
        switch current {
        case .english:
            return Locale(identifier: "en_GB")
        case .russian:
            return Locale(identifier: "ru_RU")
        case .armenian:
            return Locale(identifier: "hy_AM")
        }
    }
    
    
    func changeLanguage(_ newValue: Language) {
        if self.current != newValue {
            self.setLanguage(newValue)
        }
    }
    
    func replaceTranslations(pairs: [String: String], for language: String) {
        // TODO: SwiftGen generated enum collection for Localizations
//        Texts.clearCache()
        Bundle.replaceTranslations(pairs: pairs, for: language)
    }
    
    // MARK: - Private
    
    private func setLanguage(_ lang: Language) {
        // TODO: SwiftGen generated enum collection for Localizations
//        Texts.clearCache()
        
        
        UserDefaults.standard.set(lang.rawValue, forKey: "_language")
        UserDefaults.standard.synchronize()
        Bundle.setLanguage(AppLanguages(rawValue: lang.rawValue) ?? .armenian)
        NotificationCenter.default.post(name: .refreshLocalizations, object: nil)
    }
}
