//
//  UIScrollView+ParallaxHeader.swift
//  ParallaxHeader
//
//  Created by LXTeamDevs
//

import UIKit

private class ParralaxView: UIView {

	let contentView: UIView
	let minHeight: CGFloat
	let heightConstraint: NSLayoutConstraint
	let parallaxType: ParallaxHeaderType
    let zPos: ParallaxZPosition
	var observationToken: NSKeyValueObservation?

    init(contentView: UIView, minHeight: CGFloat, type: ParallaxHeaderType, zPos: ParallaxZPosition) {
		self.contentView = contentView
		self.minHeight = minHeight
		self.heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
		self.parallaxType = type
        self.zPos = zPos
		super.init(frame: contentView.bounds)
		backgroundColor = .clear
		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		self.heightConstraint.isActive = true
        
        if zPos == .back {
            layer.zPosition = CGFloat(-1 * Float.greatestFiniteMagnitude)
        } else {
            layer.zPosition = 900
        }
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var scrollView: UIScrollView? {
		return superview as? UIScrollView
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		setupScrollView()
	}

	override func willMove(toSuperview newSuperview: UIView?) {
		guard superview is UIScrollView else { return }
		observationToken?.invalidate()
	}

	deinit {
		observationToken?.invalidate()
	}

	private func setupScrollView() {
		guard let scrollView = scrollView else { return }
		scrollView.sendSubviewToBack(self)
		observationToken = scrollView.observe(\.contentOffset, options: [.initial, .new]) {[weak self] (scrollView, change) in
			guard let self = self else { return }
			self.refreshContent()
		}
	}

	private func refreshContent() {
		guard let scrollView = scrollView else { return }
		let topInset = scrollView.adjustedContentInset.top

		var frame = self.frame
		frame.size.width = scrollView.frame.width
		frame.origin.x = scrollView.bounds.origin.x
		if scrollView.bounds.origin.y < -topInset {
			frame.origin.y = scrollView.bounds.origin.y
			frame.size.height = abs(scrollView.bounds.origin.y)
			self.heightConstraint.constant = abs(scrollView.bounds.origin.y)
//            print("!!! ", frame)
		} else {
			if scrollView.bounds.origin.y + minHeight > 0 {
				frame.origin.y = scrollView.bounds.origin.y//scrollView.bounds.origin.y - (minHeight + scrollView.bounds.origin.y)
				frame.size.height = scrollView.bounds.origin.y < 0
                    ? (abs(min(scrollView.bounds.origin.y, 0)) + (minHeight + scrollView.bounds.origin.y))
                    : minHeight
			} else {
				frame.origin.y = scrollView.bounds.origin.y
				frame.size.height = abs(min(scrollView.bounds.origin.y, 0))
			}

			self.heightConstraint.constant = self.parallaxType == .fill ? frame.size.height : topInset
		}

		self.frame = frame
		self.layoutIfNeeded()
        
        if zPos == .back {
            scrollView.sendSubviewToBack(self)
        } else {
            scrollView.bringSubviewToFront(self)
        }
	}
}

public enum ParallaxHeaderType {
	case fill
	case top
}

public enum ParallaxZPosition {
    case front
    case back
}

public extension UIScrollView {
    func addParallaxHeader(header: UIView, minHeight: CGFloat = 0, type: ParallaxHeaderType = .fill, zPosition: ParallaxZPosition = .back) {
		let parallaxView = ParralaxView(contentView: header, minHeight: minHeight, type: type, zPos: zPosition)
		addSubview(parallaxView)
	}
}
