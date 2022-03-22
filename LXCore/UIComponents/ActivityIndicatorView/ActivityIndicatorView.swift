//
//  ActivityIndicatorView.swift
//  Upay
//
//  Created by Ani  Mkrtchyan on 8/10/21.
//

import Foundation
import UIKit

class ActivityIndicatorView: UIView {
    private enum Constants {
        static let startColor: UIColor = .clear
        // TODO: remove hardcoded color
        static let endColor: UIColor = .red
        // TODO: remove hardcoded color
        static let backgroundColor: UIColor = .green.withAlphaComponent(0.5)
    }
    
    static let shared = ActivityIndicatorView(frame: UIScreen.main.bounds)
    private(set) var isAnimating: Bool = false
    
    private var arcView: GradientArcView = {
        let view = GradientArcView(frame: CGRect(origin: .zero, size: CGSize(width: 48, height: 48)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 48).isActive = true
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        view.startColor = Constants.startColor
        view.endColor = Constants.endColor
        return view
    }()
    
    private var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = Constants.backgroundColor
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        addSubview(backgroundView)
        addSubview(arcView)
        arcView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        arcView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true        
    }
    
    func startAnimating() {
        guard !isAnimating, let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) else { return }
        isAnimating = true
        setNeedsLayout()
        layoutIfNeeded()
        alpha = 0
        window.addSubview(self)
        internalStartAnimating()
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
    }
    
    func stopAnimating() {
        guard isAnimating else { return }
        isAnimating = false
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { (_) in
            self.internalStopAnimating()
            self.removeFromSuperview()
        }
    }
    
    private func internalStartAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        arcView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func internalStopAnimating() {
        arcView.layer.removeAllAnimations()
    }
}
