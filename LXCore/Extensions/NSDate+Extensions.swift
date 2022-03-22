//
//  NSDate+Extensions.swift
//  APITest
//
//  Created by Hovhannes Stepanyan on 12/25/18.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation


extension Date {
	private static var onlyDayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    static var iso8601Formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    func toLocalTimeZone() -> Date {
        let tz = TimeZone.current
        let seconds = tz.secondsFromGMT(for: self)
        return Date(timeInterval: TimeInterval(seconds), since: self)
    }
    
    func toGlobalTime() -> Date {
        let tz = TimeZone.current
        let seconds = -(tz.secondsFromGMT(for: self))
        return Date(timeInterval: TimeInterval(seconds), since: self)
    }
    
    func toISO8601() -> String {
        return Date.onlyDayFormatter.string(from: self) + "T00:00:00+04:00"
    }
    
    init?(fromISO8601 str: String) {
        guard let date = Date.iso8601Formatter.date(from: str) else {
            return nil
        }
        self = date
    }
}
