//
//  UIViewController+Extensions.swift
//
//  Created by LXTeamDevs on 5/21/19.
//

import UIKit

extension UIViewController {
    func isLastInNavigation() -> Bool {
        guard let nc = navigationController else {
            return view.window != nil
        }
        
        let topVC = nc.topViewController
        if topVC == self {
            return true
        }
        
        let children = topVC?.children
        return children?.contains(self) ?? false
    }
    
    func isDarkMode() -> Bool {
        if #available(iOS 13.0, *) {
            return traitCollection.userInterfaceStyle == .dark
        } else {
            return true
        }
    }

    func addChildViewController(_ child: UIViewController, to view: UIView) {
        child.view.frame = view.bounds
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

}
