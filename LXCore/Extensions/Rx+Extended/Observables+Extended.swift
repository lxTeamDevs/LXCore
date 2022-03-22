//
//  Helper.swift
//  Shared
//
//  Created by Artur Mkrtchyan on 2/23/20.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public typealias BehaviorRelay = RxCocoa.BehaviorRelay
public typealias Disposables = RxSwift.Disposables
public typealias DisposeBag = RxSwift.DisposeBag
public typealias Driver = RxCocoa.Driver
public typealias MainScheduler = RxSwift.MainScheduler
public typealias Observable = RxSwift.Observable
public typealias PublishRelay = RxCocoa.PublishRelay
public typealias PublishSubject = RxSwift.PublishSubject
public typealias ReplaySubject = RxSwift.ReplaySubject
public typealias Single = RxSwift.Single

extension Driver {
	
	public func withLatestFromTwo<FirstO, SecondO>(_ first:FirstO ,_ second: SecondO) -> SharedSequence<SharingStrategy, (FirstO.Element, SecondO.Element)>
		where
		FirstO : SharedSequenceConvertibleType,
		SecondO: SharedSequenceConvertibleType,
		SecondO.SharingStrategy == SharingStrategy {
			return self.withLatestFrom(first).withLatestFrom(second) { ($0, $1) }
	}
	
	public func withLatestFromThree<FirstO, SecondO, ThirdO>(_ first:FirstO ,_ second: SecondO, _ third: ThirdO) -> SharedSequence<SharingStrategy, (FirstO.Element, SecondO.Element, ThirdO.Element)>
		where
		FirstO : SharedSequenceConvertibleType,
		SecondO: SharedSequenceConvertibleType,
		ThirdO: SharedSequenceConvertibleType,
		SecondO.SharingStrategy == SharingStrategy,
		ThirdO.SharingStrategy == SharingStrategy {
			return self.withLatestFrom(first).withLatestFrom(second) { ($0, $1) }.withLatestFrom(third) {($0.0, $0.1, $1)}
	}
}

extension ObservableType {
	public func withLatestFromTwo<FirstO, SecondO>(_ first:FirstO ,_ second: SecondO) -> Observable<(FirstO.Element, SecondO.Element)>
		where
		FirstO : ObservableConvertibleType,
		SecondO: ObservableConvertibleType {
			return self.withLatestFrom(first).withLatestFrom(second) { ($0, $1) }
	}
}

public extension Observable {
	
	func asDriver(_ `default`: Element) -> Driver<Element> {
		return asDriver(onErrorJustReturn: `default`)
	}
	
	func void() -> Observable<Void> {
		return map { _ in }
	}
	
	static func void() -> Observable<Void> {
		return .just(())
	}
}

extension Observable where Element == Void {
	public func asDriver() -> Driver<Void> {
		return self.asDriver(onErrorJustReturn: ())
	}
}

extension Observable where Element == Bool {
	public func asDriver() -> Driver<Bool> {
		return self.asDriver(onErrorJustReturn: false)
	}
}

extension Observable where Element == String {
	public func asDriver() -> Driver<String> {
		return self.asDriver(onErrorJustReturn: "")
	}
}

extension Observable where Element == NSAttributedString {
	public func asDriver() -> Driver<NSAttributedString> {
		return self.asDriver(onErrorJustReturn: NSAttributedString(string: ""))
	}
}

extension Observable where Element == Double {
	public func asDriver() -> Driver<Double> {
		return self.asDriver(onErrorJustReturn: 0)
	}
}

public extension SharedSequenceConvertibleType {
	
	func void() -> SharedSequence<SharingStrategy, Void> {
		return map{ _ in }
	}
	
	static func void() -> SharedSequence<SharingStrategy, Void> {
		return .just(())
	}
}

public extension SharedSequence where Element == Bool {
	func ifTrue(do block:@escaping () -> Void) -> SharedSequence<SharingStrategy, Bool> {
		return self.map { val in
			if val {
				block()
			}
			return val
		}
	}

	func ifNotTrue(do block:@escaping () -> Void) -> SharedSequence<SharingStrategy, Bool> {
		return self.map { val in
			if !val {
				block()
			}
			return val
		}
	}
}

public extension SharedSequence {
	func doVoid(onNext: (() -> Void)?) -> RxCocoa.SharedSequence<Self.SharingStrategy, Self.Element> {
		self.do(onNext: { (_) in
			onNext?()
		})
	}
}

public extension ObservableType {
	func doVoid(onNext: (() -> Void)?) -> Observable<Element> {
		return self.do(onNext: { (_) in
			onNext?()
		})
	}
}

public protocol OptionalType {
	
	associatedtype Wrapped
	
	var optional: Wrapped? { get }
}

extension Optional: OptionalType {

	public var optional: Wrapped? { return self }
	public var notNil: Bool {
		return self != nil
	}
	public var isNil: Bool {
		return self == nil
	}
}

extension ObserverType where Element == Void {
	public func onNext() {
		self.on(.next(()))
	}
}

extension ObservableType {
    public func withPrevious() -> Observable<(Element, Element)> {
		return Observable.zip(self, skip(1))
    }
}

public final class ReadOnlyBehaviorRelay<Element>: ObservableType {
    public typealias E = Element

    private let variable: BehaviorRelay<Element>

    public convenience init(_ value: Element) {
		self.init(BehaviorRelay(value: value))
    }

    public init(_ variable: BehaviorRelay<Element>) {
        self.variable = variable
    }

    public var value: E {
        return variable.value
    }

    public func asObservable() -> Observable<E> {
        return variable.asObservable()
    }

	public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self.variable.subscribe(observer)
    }
}

public extension BehaviorRelay {
    func asReadOnly() -> ReadOnlyBehaviorRelay<Element> {
        return ReadOnlyBehaviorRelay(self)
    }
}

public protocol DisposeBagOwner: AnyObject {
	var disposeBag: DisposeBag { get }
}
