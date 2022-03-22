//
//  Driver+Bind.swift
//  FastShift
//
//  Created by Ani  Mkrtchyan on 3/24/21.
//

import Foundation
import RxSwift
import RxCocoa

public extension DisposeBagOwner {
    func bind<T: AnyObject, U>(_ driver: Driver<U>, closure:@escaping (T) -> (U) -> Void) {
        driver.drive(onNext: {[weak self] (input) in
            self.map({ closure($0 as! T)(input) })
        }).disposed(by: disposeBag)
    }

    func bind<U>(_ driver: Driver<U>, closure: ((U) -> Void)?) {
        driver.drive(onNext: closure).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<Void>, closure:@escaping () -> Void) {
        driver.drive(onNext: closure).disposed(by: disposeBag)
    }

    func bind<T: AnyObject>(_ driver: Driver<Void>, closure:@escaping (T) -> () -> Void) {
        driver.drive(onNext: {[weak self] in
            self.map({ closure($0 as! T)() })
        }).disposed(by: disposeBag)
    }

    func bind<T, O: ObserverType>(_ driver: Driver<T>, _ bindable: O) where O.Element == T {
        driver.drive(bindable).disposed(by: disposeBag)
    }

    func bind<T>(_ driver: Driver<T>, _ bindable: BehaviorRelay<T>) {
        driver.drive(bindable).disposed(by: disposeBag)
    }

    func bind<T, O: ObserverType>(_ driver: Driver<T>, _ bindable: O) where O.Element == Optional<T> {
        driver.drive(bindable).disposed(by: disposeBag)
    }

    func bind<T: ObservableType, O: ObserverType>(_ binder: T, _ bindable: O) where O.Element == T.Element {
        binder.bind(to: bindable).disposed(by: disposeBag)
    }

    func bind<T: ObservableType, O: ObserverType>(_ binder: T, _ bindable: O) where O.Element == Optional<T.Element> {
        binder.bind(to: bindable).disposed(by: disposeBag)
    }
}

//UIKit
public extension DisposeBagOwner {
    func bind(_ driver: Driver<String>, _ bindable: UILabel!) {
        driver.drive(bindable.rx.text).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<String>, _ bindable: UIButton!) {
        driver.drive(bindable.rx.title(for: .normal)).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<String?>, _ bindable: UILabel!) {
        driver.drive(bindable.rx.text).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<String?>, _ bindable: UIButton!) {
        driver.drive(bindable.rx.title(for: .normal)).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<String>, _ bindable: UITextField!) {
        driver.drive(bindable.rx.text).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<String?>, _ bindable: UITextField!) {
        driver.drive(bindable.rx.text).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<NSAttributedString>, _ bindable: UIButton!) {
        driver.drive(bindable.rx.attributedTitle(for: .normal)).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<NSAttributedString?>, _ bindable: UIButton!) {
        driver.drive(bindable.rx.attributedTitle(for: .normal)).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<UIColor>, _ bindable: UILabel!) {
        driver.drive(onNext: { (color) in bindable.textColor = color }).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<UIColor?>, _ bindable: UILabel!) {
        driver.drive(onNext: { (color) in bindable.textColor = color }).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<UIColor>, _ bindable: UITextField!) {
        driver.drive(onNext: { (color) in bindable.textColor = color }).disposed(by: disposeBag)
    }

    func bind(_ driver: Driver<UIColor?>, _ bindable: UITextField!) {
        driver.drive(onNext: { (color) in bindable.textColor = color }).disposed(by: disposeBag)
    }
}
