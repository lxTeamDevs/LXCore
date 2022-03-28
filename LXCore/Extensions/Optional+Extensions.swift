//
//  Optional+Extensions.swift
//  ACBA-MobileBanking
//
//  Created by Ani  Mkrtchyan on 3/6/21.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Bool {
    var isTrue: Bool {
        return self == true
    }
    
    var isFalse: Bool {
        return self == false
    }
}

public extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    var isNotEmpty: Bool {
        return !isNilOrEmpty
    }
}

public extension Optional {
    func valueOr(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
}

public func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?): return l < r
    case (nil, _?): return true
    default: return false }
}

public func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


public func == <T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l == r
    case (nil, nil):
        return true
    default:
        return false
    }
}
