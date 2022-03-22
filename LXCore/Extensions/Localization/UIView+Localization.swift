import UIKit

extension NSNotification.Name {
    static let refreshLocalizations = Notification.Name("kRefreshLocalizations")
    static let refreshCards = Notification.Name("krefreshCards")
}

private struct LocalizationKeys {
    static var LocalizedKey = "localizedKey"
}

extension UIView {
    
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
        
        switch self {
        case let label as UILabel:
            if localizedText == nil {
                setLocalizedKey(label.text)
                localizedText = NSLocalizedString(label.text ?? "", comment: "")
            }
			if let localizedText = localizedText, localizedText.contains("<b>") {
				let str = htmlToAttributedString(string: localizedText, font: label.font, color: label.textColor, alignment: label.textAlignment)
				label.attributedText = str
			} else {
				label.text = localizedText
			}
        case let textField as UITextField:
            if localizedText == nil {
                setLocalizedKey(textField.placeholder)
                localizedText = NSLocalizedString(textField.placeholder ?? "", comment: "")
            }
            textField.placeholder = localizedText
        case let textView as UITextView:
            if localizedText == nil {
                setLocalizedKey(textView.text)
                localizedText = NSLocalizedString(textView.text ?? "", comment: "")
            }
            textView.text = localizedText
        case let button as UIButton:
            if localizedText == nil {
                if (button.titleLabel?.text ?? "").isEmpty {
                    return
                }
                setLocalizedKey(button.titleLabel?.text)
                localizedText = NSLocalizedString(button.titleLabel?.text ?? "", comment: "")
            }

			UIView.setAnimationsEnabled(false)

			if let localizedText = localizedText, localizedText.contains("<b>") {
				let str = htmlToAttributedString(string: localizedText,
												 font: button.titleLabel?.font ?? .systemFont(ofSize: 17),
												 color: button.titleColor(for: .normal) ?? .black,
												 alignment: button.titleLabel?.textAlignment ?? .center)
				button.setAttributedTitle(str, for: .normal)
			} else {
				button.setTitle(localizedText, for: .normal)
			}

			if let selectedStateText = button.title(for: .selected) {
				let localizedSelectedText = NSLocalizedString(selectedStateText, comment: "")
				if localizedSelectedText.contains("<b>") {
					let str = htmlToAttributedString(string: localizedSelectedText,
													 font: button.titleLabel?.font ?? .systemFont(ofSize: 17),
													 color: button.titleColor(for: .selected) ?? .black,
													 alignment: button.titleLabel?.textAlignment ?? .center)
					button.setAttributedTitle(str, for: .selected)
				} else {
					button.setTitle(localizedSelectedText, for: .selected)
				}
			}

            button.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
        case let navigationBar as UINavigationBar:
            if localizedText == nil {
                setLocalizedKey(navigationBar.topItem?.title)
                localizedText = NSLocalizedString(navigationBar.topItem?.title ?? "", comment: "")
            }
            navigationBar.topItem?.title = localizedText
        default:
            break
        }
    }
}

fileprivate func htmlToAttributedString(string : String, font: UIFont, color: UIColor, alignment: NSTextAlignment) -> NSAttributedString{
	var attribStr = NSMutableAttributedString()
	var csstextalign = "left"
	switch alignment {
	case .center:
		csstextalign = "center"
	case .right:
		csstextalign = "right"
	case .justified:
		csstextalign = "justify"
	default: break
	}

	do {//, allowLossyConversion: true
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; text-align: \(csstextalign);}</style>\(string)";
		attribStr = try NSMutableAttributedString(data: modifiedString.data(using: .utf8)!,
												  options:  [.documentType: NSAttributedString.DocumentType.html,
															 .characterEncoding: String.Encoding.utf8.rawValue],
												  documentAttributes: nil)
		let textRangeForFont : NSRange = NSMakeRange(0, attribStr.length)
		attribStr.addAttributes([.foregroundColor : color], range: textRangeForFont)
	} catch {
		print(error)
	}

	return attribStr
}
