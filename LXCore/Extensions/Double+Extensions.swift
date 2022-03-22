//
//  Double+Extensions.swift
//  ACBA-MobileBanking
//
//  Created by Ani Mkrtchyan on 7/8/20.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation

extension Double {
    func toIntegralString() -> String {
        return String(format: "%.10f", self).components(separatedBy: ".").first ?? "0"
    }
}
