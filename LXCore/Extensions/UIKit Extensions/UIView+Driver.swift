//
//  UIView+Driver.swift
//  View
//
//  Created by Artur Mkrtchyan on 2/19/20.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIButton {
	func driver() -> Driver<()> {
		return rx.tap.asDriver()
	}

	func driverSelf() -> Driver<UIButton> {
		return rx.tap.asDriver().map({self})
	}
}

extension UITextField {
	func driver() -> Driver<String?> {
		return rx.text.asDriver()
	}
}

extension UITapGestureRecognizer {
	func driver() -> Driver<()> {
		return rx.event.asDriver().void()
	}
}

extension UISwitch {
	func driver() -> Driver<Bool> {
		return rx.controlEvent(.valueChanged).map({self.isOn}).asDriver(false)
	}
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element == String {
	func drive(_ label: UILabel) -> Disposable {
		return self.drive(label.rx.text)
	}

	func drive(_ label: UITextField) -> Disposable {
		return self.drive(label.rx.text)
	}

	func drive(_ label: UITextView) -> Disposable {
		return self.drive(label.rx.text)
	}
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, Element == String? {
	func drive(_ label: UILabel) -> Disposable {
		return self.drive(label.rx.text)
	}

	func drive(_ label: UITextField) -> Disposable {
		return self.drive(label.rx.text)
	}

	func drive(_ label: UITextView) -> Disposable {
		return self.drive(label.rx.text)
	}
}
