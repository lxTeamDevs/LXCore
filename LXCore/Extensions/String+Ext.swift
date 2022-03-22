//
//  String+Ext.swift
//
//  Created by Ani on 10/17/19.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import UIKit

extension String {
	func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
		var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
		for index in 0 ..< pattern.count {
			guard index < pureNumber.count else { return pureNumber }
			//let stringIndex = String.Index(encodedOffset: index)
			let stringIndex = String.Index(utf16Offset: index, in: pattern)
			let patternCharacter = pattern[stringIndex]
			guard patternCharacter != replacmentCharacter else { continue }
			pureNumber.insert(patternCharacter, at: stringIndex)
		}
		return pureNumber
	}

	func removeExtraNewLines() -> String {
		return self
			.replacingOccurrences(of: "\t", with: "")
			.replacingOccurrences(of: " \r ", with: " \n") //enter
			.replacingOccurrences(of: "\r ", with: "\n ")
			.replacingOccurrences(of: "\r\n", with: "\n")
			.replacingOccurrences(of: "\n\r", with: "\n")
			.replacingOccurrences(of: "\n ", with: "\n")
			.replacingOccurrences(of: "  ", with: " ")
			.replacingOccurrences(of: "  ", with: " ")
			.trimmingCharacters(in: .whitespacesAndNewlines)
	}
    
    func removeNonNumbers() -> String {
        return filter("0123456789.".contains)
    }
    
    func removeNonDigits() -> String {
        return filter("0123456789".contains)
    }
    
    func replaceWithAsterisks(starting from: Int) -> String {
        let str =  (self as NSString)
        let replaceLength = self.count - from
        let range = NSMakeRange(from, replaceLength)
        return str.replacingCharacters(in: range, with: String(repeating: "*", count: replaceLength))
    }
    
    func toDouble() -> Double? {
        let clearedText = removeNonNumbers()
        // TODO: From upay. Clarify why isNotEmpty not recognizing
//        guard clearedText.isNotEmpty else { return 0 }
        return Double(clearedText)
    }
    
    func toInt() -> Int? {
        let clearedText = removeNonDigits()
        // TODO: From upay. Clarify why isNotEmpty not recognizing
//        guard clearedText.isNotEmpty else { return 0 }
        return Int(clearedText)
    }
}

public extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    var containsAlphabets: Bool {
        //Checks if all the characters inside the string are alphabets
        let set = CharacterSet.letters
        return self.utf16.contains {
            guard let unicode = UnicodeScalar($0) else { return false }
            return set.contains(unicode)
        }
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
        
    }
}


extension UITextField {
	func setPatternedText(_ text: String?) {
		let selection = selectedTextRange
		self.text = text
		if let selection = selection {
			var cursorPosition = selection.start
			let location = self.offset(from: self.beginningOfDocument, to: cursorPosition) - 1
			if
				let text = self.text,
				location >= 0,
				location < text.count,
				text[location] == " " {
				cursorPosition = self.position(from: selection.start, offset: 1) ?? cursorPosition
			}
			selectedTextRange = self.textRange(from: cursorPosition, to: cursorPosition)
		}
	}
}

