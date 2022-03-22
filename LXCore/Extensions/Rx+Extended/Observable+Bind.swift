//
//  Observable+Bind.swift
//  FastShift
//
//  Created by Ani  Mkrtchyan on 3/24/21.
//

import Foundation
import RxSwift
import RxCocoa

public extension DisposeBagOwner {
    func bind<T: AnyObject, U>(_ obs: BehaviorRelay<U>, closure:@escaping (T) -> (U) -> Void) {
        obs.subscribe(onNext: {[weak self] (input) in
            self.map({ closure($0 as! T)(input) })
        }).disposed(by: disposeBag)
    }

    func bind<U>(_ obs: BehaviorRelay<U>, closure: ((U) -> Void)?) {
        obs.subscribe(onNext: closure).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<Void>, closure:@escaping () -> Void) {
        obs.subscribe(onNext: closure).disposed(by: disposeBag)
    }

    func bind<T: AnyObject>(_ obs: BehaviorRelay<Void>, closure:@escaping (T) -> () -> Void) {
        obs.subscribe(onNext: {[weak self] in
            self.map({ closure($0 as! T)() })
        }).disposed(by: disposeBag)
    }

    func bind<T, O: ObserverType>(_ obs: BehaviorRelay<T>, _ bindable: O) where O.Element == T {
        obs.subscribe(bindable).disposed(by: disposeBag)
    }

    func bind<T>(_ obs: BehaviorRelay<T>, _ bindable: BehaviorRelay<T>) {
        obs.bind(to: bindable).disposed(by: disposeBag)
    }

    func bind<T, O: ObserverType>(_ obs: BehaviorRelay<T>, _ bindable: O) where O.Element == Optional<T> {
        obs.bind(to: bindable).disposed(by: disposeBag)
    }
}

//UIKit
public extension DisposeBagOwner {
    func bind(_ obs: BehaviorRelay<String>, _ bindable: UILabel!) {
        obs.bind(to: bindable.rx.text).disposed(by: disposeBag)
    }
    
    func bind(_ obs: BehaviorRelay<String>, _ bindable: UIButton!) {
        obs.bind(to: bindable.rx.title(for: .normal)).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<String?>, _ bindable: UILabel!) {
        obs.subscribe(bindable.rx.text).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<String?>, _ bindable: UIButton!) {
        obs.subscribe(bindable.rx.title(for: .normal)).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<String>, _ bindable: UITextField!) {
        obs.bind(to: bindable.rx.text).disposed(by: disposeBag)
    }

    func bind(_ textField: UITextField, _ bindable: BehaviorRelay<String?>) {
        textField.rx.text.bind(to: bindable).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<String?>, _ bindable: UITextField!) {
        obs.subscribe(bindable.rx.text).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<NSAttributedString>, _ bindable: UIButton!) {
        obs.bind(to: bindable.rx.attributedTitle(for: .normal)).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<NSAttributedString?>, _ bindable: UIButton!) {
        obs.subscribe(bindable.rx.attributedTitle(for: .normal)).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<UIColor>, _ bindable: UILabel!) {
        obs.subscribe(onNext: { (color) in bindable.textColor = color }).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<UIColor?>, _ bindable: UILabel!) {
        obs.subscribe(onNext: { (color) in bindable.textColor = color }).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<UIColor>, _ bindable: UITextField!) {
        obs.subscribe(onNext: { (color) in bindable.textColor = color }).disposed(by: disposeBag)
    }

    func bind(_ obs: BehaviorRelay<UIColor?>, _ bindable: UITextField!) {
        obs.subscribe(onNext: { (color) in bindable.textColor = color }).disposed(by: disposeBag)
    }
    
    func bind(_ obs: BehaviorRelay<Bool>, _ bindable: UISwitch!) {
        obs.subscribe(bindable.rx.isOn).disposed(by: disposeBag)
    }
}
