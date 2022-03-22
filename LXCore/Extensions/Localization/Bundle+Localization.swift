import Foundation

enum AppLanguages: String, CaseIterable {
    case english = "en"
    case armenian = "hy"
    case russian = "ru"
}

private struct AssociatedKeys {
    static var bundle = "_bundle"
}

private class BundleEx: Bundle {
    static var currentLangauge: AppLanguages = .english
    static var replacedTranslations: [String: [String: String]] = [:]
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if
            let languageDic = BundleEx.replacedTranslations[BundleEx.currentLangauge.rawValue],
            let val = languageDic[key] {
            return val
        }
        if let bundle = objc_getAssociatedObject(self, &AssociatedKeys.bundle) as? Bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

extension Bundle {
    private class DispatchOnce {
        static let initialize: Void = {
            _ = exchangeBundles
            _ = copyBundlesToDocuments
        } ()
        
        static let exchangeBundles: Any? = {object_setClass(Bundle.main, BundleEx.self)}()
        static let copyBundlesToDocuments: Any? = {
            AppLanguages.allCases.map { $0.rawValue }.forEach { try? copyLPROJToDocumentsDir($0) }
        }()
    }
    
    static func setLanguage(_ language: AppLanguages) {
        BundleEx.currentLangauge = language
        setLanguage(language.rawValue)
    }
    
    static func setLanguage(_ name: String) {
        _ = DispatchOnce.initialize
        guard let documentsURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return }
        let url = documentsURL.appendingPathComponent(name + ".lproj")
        let value = Bundle(url: url)
        objc_setAssociatedObject(Bundle.main, &AssociatedKeys.bundle, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    static func replaceTranslations(pairs: [String: String], for language: String) {
        DispatchOnce.initialize
        var dic = BundleEx.replacedTranslations[language] ?? [:]
        for (key, value) in pairs {
            dic[key] = value
        }
        BundleEx.replacedTranslations[language] = dic
    }
}

private func copyLPROJToDocumentsDir(_ name: String) throws {
    guard
        let url = Bundle.main.url(forResource: name, withExtension: "lproj"),
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return }
    
    if !FileManager.default.fileExists(atPath: appSupportURL.path) {
        try FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    let destination = appSupportURL.appendingPathComponent(url.lastPathComponent)
    
    try? FileManager.default.removeItem(at: destination)
    try FileManager.default.copyItem(at: url, to: destination)
}
