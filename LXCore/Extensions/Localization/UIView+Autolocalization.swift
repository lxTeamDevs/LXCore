import UIKit

/// This is a simple object whose job is to execute
/// some closure when it deinitializes
class DeinitializationObserver {
    
    let execute: () -> Void
    
    init(execute: @escaping () -> Void) {
        self.execute = execute
    }
    
    deinit {
        execute()
    }
}

/// We're using objc associated objects to have this `DeinitializationObserver`
/// stored inside the protocol extension
private struct AssociatedKeys {
    static var DeinitializationObserver = "DeinitializationObserver"
}

/// Protocol for any object that implements this logic
protocol ObservableDeinitialization: AnyObject {
    func onDeinit(_ execute: @escaping () -> Void)
}

extension ObservableDeinitialization {
    
    /// This stores the `DeinitializationObserver`. It's fileprivate so you
    /// cannot interfere with this outside. Also we're using a strong retain
    /// which will ensure that the `DeinitializationObserver` is deinitialized
    /// at the same time as your object.
    fileprivate var deinitializationObserver: DeinitializationObserver {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &AssociatedKeys.DeinitializationObserver) as! DeinitializationObserver
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.DeinitializationObserver,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    /// This is what you call to add a block that should execute on `deinit`
    func onDeinit(_ execute: @escaping () -> Void) {
        deinitializationObserver = DeinitializationObserver(execute: execute)
    }
}

extension UIView: ObservableDeinitialization {}

extension UIBarItem: ObservableDeinitialization {}
