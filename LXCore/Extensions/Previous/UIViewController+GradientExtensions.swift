//
//  UIViewController+Extensions.swift
//  FastShift
//
//  Created by Rafael Nalbandyan on 2/26/22.
//  Copyright © 2022 LXTeamDevs. All rights reserved.

import Foundation
import UIKit


extension UIViewController {
    
    func configurateGradientNavigationBar(show: Bool) {
        guard
            let navigationController = navigationController,
            let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar,
                                                                     firstColor: .green, secondColor: .red)
            else {
                print("Error creating gradient color!")
                return
            }
        navigationController.navigationBar.scrollEdgeAppearance?.backgroundColor = show ? UIColor(patternImage: flareGradientImage) : .white
        navigationController.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
    }
}
