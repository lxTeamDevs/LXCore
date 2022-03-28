//
//  UIDevice+Extensions.swift
//  ACBA-MobileBanking
//
//  Created by LXTeamDevs on 5/24/19.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isIPhone4Or5: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.width == 320
    }
    
    var udid: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

}

