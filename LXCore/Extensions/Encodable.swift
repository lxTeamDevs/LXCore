//
//  Encodable.swift
//  ACBA-MobileBanking
//
//  Created by Tatevik Tovmasyan on 9/23/19.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary(encodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) throws -> [String: Any] {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = encodingStrategy
        let data = try jsonEncoder.encode(self)
        guard var dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        let keysToRemove = dictionary.keys.filter {
          guard let value = dictionary[$0] else { return false }
          return (value as! NSObject) == NSNull()
        }
        for key in keysToRemove {
            dictionary.removeValue(forKey: key)
        }
        return dictionary
    }
    
    func asArrayOfDictionaries() throws -> [[String: Any]] {
        let data = try JSONEncoder().encode(self)
        guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else {
            throw NSError()
        }
        let filtered = array.map { (d) -> [String: Any] in
            var dictionary = d
            let keysToRemove = dictionary.keys.filter {
              guard let value = dictionary[$0] else { return false }
              return (value as! NSObject) == NSNull()
            }
            for key in keysToRemove {
                dictionary.removeValue(forKey: key)
            }
            return dictionary
        }
        return filtered
    }
}
