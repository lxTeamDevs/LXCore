//
//  UIScrollView+Extensions.swift
//  ACBA-MobileBanking
//
//  Created by Ani on 9/29/19.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated:Bool = true, completion: (() -> Void)? = nil) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        guard bottomOffset.y >= 0, bottomOffset.y != contentOffset.y else {
            completion?()
            return
        }
        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            print("_______ scrolling to : ", bottomOffset)
            self.setContentOffset(bottomOffset, animated: animated)
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                completion?()
            })
        }
    }
}

