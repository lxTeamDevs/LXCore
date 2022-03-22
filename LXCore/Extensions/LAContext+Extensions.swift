//
//  LAContext+Extensions.swift
//  FastShift
//
//  Created by Ani  Mkrtchyan on 5/21/21.
//

import LocalAuthentication

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                return .none
            }
        } else {
            return self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
    
    func authUser(localizedReason: String, callback: @escaping (Bool, Error?) -> Void) {
        var error: NSError?
        if canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) {
                callback($0, $1)
            }
        } else {
            callback(false, error)
        }
    }
}

