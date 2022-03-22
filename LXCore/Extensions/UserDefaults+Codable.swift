//
//  UserDefaults+Codable.swift
//  Shared
//
//  Created by Artur Mkrtchyan on 9/28/20.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation

extension UserDefaults {
	public func set<Element: Codable>(value: Element, forKey key: String) {
		let data = try? JSONEncoder().encode(value)
		setValue(data, forKey: key)
	}

	public func codable<Element: Codable>(forKey key: String, _ type: Element.Type) -> Element? {
		guard let data = data(forKey: key) else { return nil }
		let element = try? JSONDecoder().decode(type, from: data)
		return element
	}
}
