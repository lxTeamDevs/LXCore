//
//  GradientView.swift
//  FastShift
//
//  Created by Rafael Nalbandyan on 2/26/22.
//

import UIKit


class GradientView: UIView {

    // MARK: - Private properties

    private var gradientLayer: CAGradientLayer!
    
    // MARK: - Override methods
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer = self.layer as? CAGradientLayer
        // TODO: remove hardcoded color
        gradientLayer.setFSGradientLayer(topColor: .green, bottomColor: .red)
    }
}
