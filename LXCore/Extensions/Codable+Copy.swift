//
//  Codable+Copy.swift
//  ACBA-MobileBanking
//
//  Created by Ani Mkrtchyan on 8/24/20.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation

protocol CopyableCodable: Codable {}
extension CopyableCodable {
    func copy() throws -> Self {
        let data = try JSONEncoder().encode(self)
        let copy = try JSONDecoder().decode(Self.self, from: data)
        return copy
    }
}
