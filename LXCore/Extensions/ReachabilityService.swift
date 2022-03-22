#if !RX_NO_MODULE
import RxSwift
#endif
import Foundation

public enum ReachabilityStatus {
    case reachable(viaWiFi: Bool)
    case unreachable
}

public extension ReachabilityStatus {
    var reachable: Bool {
        switch self {
        case .reachable:
            return true
        case .unreachable:
            return false
        }
    }
}

public protocol ReachabilityService {
    var reachability: Observable<ReachabilityStatus> { get }
}

enum ReachabilityServiceError: Error {
    case failedToCreate
}

open class DefaultReachabilityService
    : ReachabilityService {

    private let _reachabilitySubject: BehaviorSubject<ReachabilityStatus>

    public var reachability: Observable<ReachabilityStatus> {
        return _reachabilitySubject.asObservable()
    }

    let _reachability: Reachability

    init() throws {
        guard let reachabilityRef = Reachability() else { throw ReachabilityServiceError.failedToCreate }
        let reachabilitySubject = BehaviorSubject<ReachabilityStatus>(value: .unreachable)

        // so main thread isn't blocked when reachability via WiFi is checked
        let backgroundQueue = DispatchQueue(label: "reachability.wificheck")

        reachabilityRef.whenReachable = { reachability in
            backgroundQueue.async {
                reachabilitySubject.on(.next(.reachable(viaWiFi: reachabilityRef.isReachableViaWiFi)))
            }
        }

        reachabilityRef.whenUnreachable = { reachability in
            backgroundQueue.async {
                reachabilitySubject.on(.next(.unreachable))
            }
        }

        try reachabilityRef.startNotifier()
        _reachability = reachabilityRef
        _reachabilitySubject = reachabilitySubject
    }

    deinit {
        _reachability.stopNotifier()
    }
}

extension ObservableConvertibleType {
    func retryOnBecomesReachable(_ valueOnFailure:Element, reachabilityService: ReachabilityService) -> Observable<Element> {
        return self.asObservable()
            .catchError { (e) -> Observable<Element> in
                    reachabilityService.reachability
                    .skip(1)
                    .filter { $0.reachable }
                    .flatMap { _ in
                        Observable.error(e)
                    }
                    .startWith(valueOnFailure)
            }
            .retry()
    }
}

class RxReachabilityService {
  static let shared = RxReachabilityService()
  var reachabilityChanged: Observable<Reachability.NetworkStatus> {
    get {
      return reachabilitySubject.asObservable()
    }

  }
  
  init() {
    reachability = Reachability.init()!

    let up = reachability.currentReachabilityStatus
    reachabilitySubject = BehaviorSubject<Reachability.NetworkStatus>(value: up)
    
    let reachabilityChangedClosure: (Reachability) -> () =  { [weak self] (reachability) in
      self?.reachabilitySubject.on(.next(reachability.currentReachabilityStatus))
    }
    
    reachability.whenReachable = reachabilityChangedClosure
    reachability.whenUnreachable = reachabilityChangedClosure

    try! reachability.startNotifier()
  }
  
  private let reachability: Reachability
  private let reachabilitySubject: BehaviorSubject<Reachability.NetworkStatus>

}

