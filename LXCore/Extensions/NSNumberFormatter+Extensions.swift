//
//  NSNumberFormatter+Extensions.swift
//  ACBA-MobileBanking
//
//  Created by LXTeamDevs on 4/29/19.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation

extension NumberFormatter {
    func string(from double: Double, takingIntoAccountCurrencySign: Bool = false) -> String? {
//        let str = string(from: NSNumber(value: double))
//        if takingIntoAccountCurrencySign {
//            let signStr = AppConfig.shared?.amdSign ?? "֏"
//            return (str ?? "0") + " " + signStr
//        }
//        return str
        return ""
    }

    func string(from int: Int) -> String? {
        return string(from: NSNumber(value: int))
    }
}
