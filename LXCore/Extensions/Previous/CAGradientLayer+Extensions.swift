//
//  CAGradientLayer+Extensions.swift
//  FastShift
//
//  Created by Rafael Nalbandyan on 2/26/22.
//  Copyright © 2022 LXTeamDevs. All rights reserved.

import Foundation
import UIKit


extension CAGradientLayer {
    
    func setFSGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let topColor: UIColor = topColor
        let bottomColor: UIColor = bottomColor
        let startPointX: CGFloat = 0.25
        let startPointY: CGFloat = 0.5
        let endPointX: CGFloat = 0.75
        let endPointY: CGFloat = 0.5
        
        self.colors = [topColor.cgColor, bottomColor.cgColor]
        self.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.endPoint = CGPoint(x: endPointX, y: endPointY)
    }
    
    class func primaryGradient(on view: UIView, firstColor: UIColor, secondColor: UIColor) -> UIImage? {
        let gradient = CAGradientLayer()
        let firstColor = firstColor
        let secondColor = secondColor
        let startPointX: CGFloat = 0.25
        let startPointY: CGFloat = 0.5
        let endPointX: CGFloat = 0.75
        let endPointY: CGFloat = 0.5
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradient.endPoint = CGPoint(x: endPointX, y: endPointY)
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}
