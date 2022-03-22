//
//  LargeAmountFormatter.swift
//  ACBA-MobileBanking
//
//  Created by Tatevik Tovmasyan on 7/1/20.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation

extension String {
    func formatLargeAmount() -> String {
        var newSelf = self
		newSelf.removeFirst0s()
		newSelf.trim()
        
        if newSelf.count <= 3 {
            return newSelf
        }
        
        var decimalPart: String = ""
        var nonDecimalPart: String = ""
        
        let fromDotToEndCount = newSelf.count - (newSelf.lastIndex(of: ".")?.utf16Offset(in: newSelf) ?? newSelf.count)
        decimalPart = String(newSelf.suffix(fromDotToEndCount))
        nonDecimalPart = String(newSelf.prefix((newSelf.lastIndex(of: ".")?.utf16Offset(in: newSelf) ?? newSelf.count)))
        
        var partThatDividesInto3: String = ""
        
        if nonDecimalPart.count % 3 != 0 {
            let index = nonDecimalPart.count % 3
            nonDecimalPart.insert(",", at: String.Index(utf16Offset: index, in: nonDecimalPart))
            partThatDividesInto3 = String(nonDecimalPart.dropFirst(index + 1))
            nonDecimalPart = String(nonDecimalPart.prefix(index + 1))
            if partThatDividesInto3 == "" {
                nonDecimalPart.removeLast() //removes semicolon since it's smth like 123.23
            }
        } else {
            partThatDividesInto3 = nonDecimalPart
            nonDecimalPart = ""
        }
        
        if partThatDividesInto3.count != 0 {
            let patternAtMaximum = "###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###,###"
             let patternCollapsed = String(patternAtMaximum.prefix(partThatDividesInto3.count + partThatDividesInto3.count/3 - 1))
            partThatDividesInto3 = partThatDividesInto3.applyPatternOnNumbers(pattern: patternCollapsed, replacmentCharacter: "#")
        }
        
        var finalString = "\(nonDecimalPart)\(partThatDividesInto3)\(decimalPart)"
        
        if fromDotToEndCount >= 3 { //making at most 2 selfbers after dot
            finalString = String(finalString.prefix(finalString.count - fromDotToEndCount + 3))
        }
        
        if finalString[String.Index(utf16Offset: finalString.count - 1, in: finalString)] == "." {
            finalString = String(finalString.dropLast())
        }
        
        return finalString
    }
    
    private mutating func removeFirst0s () {
        guard self.count >= 2 else { return }
        if self[String.Index(utf16Offset: 0, in: self)] == "0" && self[String.Index(utf16Offset: 1, in: self)] != "." {
            self = String(self.dropFirst())
            self.removeFirst0s()
        } else {
            return
        }
    }

	private mutating func trim() {
		self = self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
