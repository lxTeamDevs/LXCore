//
//  GradientButton.swift
//  FastShift
//
//  Created by Rafael Nalbandyan on 2/26/22.
//

import Foundation
import UIKit

class GradientButton: UIButton {
    
    enum ButtonState: Int {
        case hasGradient
        case hasBorder
    }
    
    @IBInspectable var stateAdapter: Int {
        get {
            return self.buttonState.rawValue
        }
        set( typeIndex) {
            self.buttonState = ButtonState(rawValue: typeIndex) ?? .hasGradient
        }
    }
    
    // MARK: - Private properties
    private var buttonState: ButtonState = .hasGradient
    private var gradientLayer: CAGradientLayer!
    
    // MARK: - Override methods
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cornerRadius = self.frame.height / 2
        // TODO: remove hardcoded color
        self.tintColor = .white
        switch buttonState {
        case .hasGradient:
            self.gradientLayer = self.layer as? CAGradientLayer
            // TODO: remove hardcoded color
            gradientLayer.setFSGradientLayer(topColor: .green, bottomColor: .red)
        case .hasBorder:
            self.borderWidth = 2
            // TODO: remove hardcoded color
            self.borderColor = .red
//            self.set = Asset.mainPurple.color
            // TODO: remove hardcoded color
            self.backgroundColor = .green
        }
        
        
    }
}
