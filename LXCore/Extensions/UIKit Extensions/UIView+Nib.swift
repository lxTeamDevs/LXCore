//
//  UIView+Nib.swift
//  View
//
//  Created by Artur Mkrtchyan on 3/6/20.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import UIKit

public extension UIView {
    /**
     Call this method to instantiate an instance of Self's class from the xib of same name.

     Usage:
     ```
     let view = MyCustomView.loadFromNib()
     ```
     - returns: An object of type MyCustomView from MyCustomView.xib file
     */
    static func loadFromNib() -> Self {
        func instanceFromNib<T: UIView>() -> T {
            let bundle = Bundle(for: T.self)
            let name = T.self.description().components(separatedBy: ".").last ?? ""
            guard let view = bundle.loadNibNamed(name, owner: nil, options: nil)?.compactMap({ $0 as? T }).last else {
                return T()
            }
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return view
        }

        return instanceFromNib()
    }
}
