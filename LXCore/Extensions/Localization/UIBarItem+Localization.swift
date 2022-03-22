import UIKit

private struct LocalizationKeys {
    static var LocalizedKey = "localizedKey"
}

extension UIBarItem {
    private func setLocalizedKey(_ key: String?) {
        objc_setAssociatedObject(self, &LocalizationKeys.LocalizedKey, key, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    @objc var localizedKey: String? {
        get {
            return objc_getAssociatedObject(self, &LocalizationKeys.LocalizedKey) as? String
        }
        set {
            setLocalizedKey(newValue)
            localize()
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        localize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshLocalizations(_:)), name: .refreshLocalizations, object: nil)
        onDeinit {
            NotificationCenter.default.removeObserver(self, name: .refreshLocalizations, object: nil)
        }
    }
    
    @objc func handleRefreshLocalizations(_ note: Notification) {
        localize()
    }
    
    func localize() {
        var localizedText: String?
        if let localizedKey = self.localizedKey {
            localizedText = NSLocalizedString(localizedKey, comment: "")
        }
        
        if localizedText == nil {
            setLocalizedKey(self.title)
            localizedText = NSLocalizedString(self.title ?? "", comment: "")
        }
        UIView.setAnimationsEnabled(false)
        self.title = localizedText
        UIView.setAnimationsEnabled(true)
    }
}
