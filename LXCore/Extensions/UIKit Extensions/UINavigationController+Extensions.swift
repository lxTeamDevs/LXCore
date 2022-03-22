//
//  UINavigationController+Extensions.swift
//  FastShift
//
//  Created by Ani  Mkrtchyan on 8/1/21.
//

import UIKit

extension UINavigationController {
    func popToType<T>(_ type: T.Type, animated: Bool = true) where T: UIViewController {
        guard
            !(visibleViewController is T),
            let vc = viewControllers.compactMap({ $0 as? T }).first else { return }
        popToViewController(vc, animated: animated)
    }
}
