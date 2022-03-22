//
//  UILabel+Extensions.swift
//  FastShift
//
//  Created by Ani  Mkrtchyan on 5/21/21.
//

import Foundation
import UIKit
 
extension UILabel {
    func setLineHeightMultiple(_ multiple: CGFloat = 1.6) {
        guard let text = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = multiple
        let attributeString = NSMutableAttributedString(string: text,
                                                        attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.attributedText = attributeString
    }
	func setLineSpacing(_ spacing: CGFloat) {
		let text = self.text
		if let text = text {
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = spacing
			let attributeString = NSMutableAttributedString(string: text,
																  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
			self.attributedText = attributeString
		}
	}

}
