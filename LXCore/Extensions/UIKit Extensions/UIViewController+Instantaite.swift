//
//  UIViewController+Instantaite.swift
//  StoryBook
//
//  Created by Artur Mkrtchyan on 2/7/18.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Usage:
     ```
     let vc = MyCustomViewController.instantiateFromStoryboard("MyStoryboard")
     ```
     - parameter name: Name of the storyboard from which you want to instantiate
     - returns: Object of type MyCustomViewController from MyStoryboard.storyboard file
     */
	static func instantiateFromStoryboard(_ name: String = "Main", _ identifier: String? = nil, bundle: Bundle? = nil) -> Self {
		let bundle = bundle ?? Bundle(for: self)
        func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
            let storyboard = UIStoryboard(name: name, bundle: bundle)
            let id = identifier ?? String(describing: self)
            let controller = storyboard.instantiateViewController(withIdentifier: id) as! T
            return controller
        }
        return instantiateFromStoryboardHelper(name)
    }
    
     func topViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

