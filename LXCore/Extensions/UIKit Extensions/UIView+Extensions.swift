//
//  UIView+Extensions.swift
//  FastShift
//
//  Created by Ani  Mkrtchyan on 5/20/21.
//

import UIKit

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func attachToParent(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        guard let superview = superview else { return }
        
        
        superview.constraints.forEach { [unowned self, superview] in
            guard $0.firstItem as? UIView == self || $0.secondItem as? UIView == self else { return }
            if [.top, .left, .bottom, .right].contains($0.firstAttribute) {
                superview.removeConstraint($0)
            }
        }
        
        topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -right).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
    }
}

extension UIView {
    func setGradeint(from: UIColor, to: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [from, to].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.bounds = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
