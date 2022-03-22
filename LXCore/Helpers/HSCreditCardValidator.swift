//
//  HSCreditCardValidator.swift
//  test
//
//  Created by Hovhannes Stepanyan on 6/8/18.
//  Copyright © 2022 LXTeamDevs. All rights reserved.
//

import UIKit

@objc
class HSCreditCardValidator: NSObject {
    @objc
    enum CreditCardType: Int {
        case Unknown = 0
        case AmericanExpress
        case BankCard
        case ChinaUnionPay
        case Dankort
        case DinersClubenRoute
        case DinersClubInternational
        case DinersClubUSAndCanada
        case DiscoverCard
        //    case InterPayment
        case JBC
        case Maestro
        case MIR
        case MasterCard
        //    case RuPay
        //    case Troy
        //    case UATP
        case Visa
        case VisaElectron
        //    case Verve
        case Arca
    }
    
    private var seporator: String!
    var allTypes: [CreditCardType] = [.Unknown, .AmericanExpress, .BankCard, .ChinaUnionPay, .Dankort,
                                      .DinersClubenRoute, .DinersClubUSAndCanada, .DinersClubInternational,
                                      .DiscoverCard, .JBC, .Maestro, .MIR, .MasterCard, .Visa, .VisaElectron, .Arca]
    
    init(seporator: String) {
        self.seporator = seporator
        super.init()
    }
    
    public func cardNumberStyleString(from string: String?, type: CreditCardType?) -> String? {
        guard var temp = string, let type = type else { return string }
        // <= 12 chars
        // 4-4-4
        // 13 char - 4-4-5
        // 14 char - 4-6-4
        // 15 char - 4-6-5 | 4-5-6 | 4-7-4
        // 16 char - 4-4-4-4
        // 17 char -
        // 18 char -
        // 19 char - 6-13 | 4-4-4-4-3
        var regExpPattern = ""
        var replaceingPattern = ""
        if temp.count >= 0 && temp.count <= 4 {
            regExpPattern = "(\\d+)"
            replaceingPattern = "$1"
        } else if temp.count > 4 && temp.count <= 8 {
            regExpPattern = "(\\d{4})(\\d+)"
            replaceingPattern = "$1" + seporator + "$2"
        } else if (temp.count > 8 && temp.count <= 13) {
            regExpPattern = "(\\d{4})(\\d{4})(\\d+)"
            replaceingPattern = "$1" + seporator + "$2" + seporator + "$3"
        } else if temp.count == 14 {
            regExpPattern = "(\\d{4})(\\d{6})(\\d+)"
            replaceingPattern = "$1" + seporator + "$2" + seporator + "$3"
        } else if temp.count == 15 {
            if type == .Maestro {
                regExpPattern = "(\\d{4})(\\d{6})(\\d+)"
                replaceingPattern = "$1" + seporator + "$2" + seporator + "$3"
            } else if type == .AmericanExpress {
                regExpPattern = "(\\d{4})(\\d{5})(\\d+)"
                replaceingPattern = "$1" + seporator + "$2" + seporator + "$3"
            } else {
                regExpPattern = "(\\d{4})(\\d{7})(\\d+)"
                replaceingPattern = "$1" + seporator + "$2" + seporator + "$3"
            }
        } else if temp.count == 16 {
            regExpPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d+)"
            replaceingPattern = "$1" + seporator + "$2"
            replaceingPattern += seporator + "$3" + seporator + "$4"
        } else if temp.count == 19 {
            if type == .ChinaUnionPay {
                regExpPattern = "(\\d{6})(\\d+)"
                replaceingPattern = "$1" + seporator + "$2"
            } else {
                regExpPattern = "(\\d{4})(\\d{4})(\\d{4})(\\d+)"
                replaceingPattern = "$1" + seporator + "$2"
                replaceingPattern += seporator + "$3" + seporator + "$4"
            }
        } else {
            return temp
        }
        temp = temp.replacingOccurrences(of: regExpPattern, with: replaceingPattern, options: .regularExpression, range: Range(NSMakeRange(0, temp.count), in: temp))
        return temp
    }
    
    // Source https://en.wikipedia.org/wiki/Luhn_algorithm
    public func isValidCardNumber(_ string: String?, for type: CreditCardType?) -> Bool {
        guard let temp = string?.replacingOccurrences(of: seporator, with: ""),
            let type = type,
            temp.count > 1 else { return false }
        if type != .Unknown {
            switch type {
            case .AmericanExpress, .DinersClubInternational:
                if temp.count > 15 {
                    return false
                }
                break
            case .ChinaUnionPay:
                if temp.count > 19 {
                    return false
                }
                break
            case .DinersClubenRoute:
                if temp.count > 14 {
                    return false
                }
                break
            case .Maestro:
                if temp.count > 19 {
                    return false
                }
                break
            case .Visa,.VisaElectron,.MasterCard,.DinersClubUSAndCanada,.DiscoverCard,
                 .JBC,.Dankort,.BankCard,.MIR,.Arca:
                if temp.count > 16 {
                    return false
                }
                break
            default:
                break
            }
            var sum = Int(temp[temp.index(temp.startIndex, offsetBy: temp.count - 1)].unicodeScalars.first!.description)!
            let numberOfDigits = temp.count
            let parity = numberOfDigits % 2
            for i in 0...numberOfDigits - 2 {
                var digit = Int(temp[temp.index(temp.startIndex, offsetBy: i)].unicodeScalars.first!.description)!
                if i % 2 == parity {
                    digit *= 2
                }
                if digit > 9 {
                    digit -= 9
                }
                sum += digit
            }
            return sum % 10 == 0
        } else {
            return false;
        }
    }
    
    static public func regExpFor(_ type: CreditCardType) -> String {
        switch type {
        case .AmericanExpress:
            return "^3[47][0-9]{0,13}$"
        case .BankCard:
            return "^56[10][0-9]{0,12}|^560[221-225][0-9]{0,10}$"
        case .ChinaUnionPay:
            return "^62[0-9]{14,17}$"
        case .Dankort:
            return "^5019[0-9]{0,12}$"
        case .DiscoverCard:
            return "^65[4-9][0-9]{0,13}|64[4-9][0-9]{0,13}|6011[0-9]{0,12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{0,10})$"
        case .DinersClubenRoute:
            return "^2[014|149][0-9]{0,11}"
        case .DinersClubInternational, .DinersClubUSAndCanada:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{0,11}$"
            //        case .RuPay:
            //            return ""
            //        case .InterPayment:
        //            return ""
        case .JBC:
            return "^(?:2131|1800|35\\d{0,3})\\d{0,11}$"
        case .Maestro:
            return "^(5018|5020|5038|6304|6759|6761|6763)[0-9]{0,15}$"
        case .MIR:
            return ""
        case .MasterCard:
            return "^5[1-5][0-9]{0,14}$"
            //        case .Troy:
        //            return ""
        case .Visa:
            return "^4[0-9]{0,12}(?:[0-9]{0,3})?$"
        case .VisaElectron:
            return "^4[026|405|508|844|913|917][0-9]{0,12}|^417500[0-9]{0,11}$"
            //        case .UATP:
            //            return ""
            //        case .Verve:
        //            return ""
        case .Arca:
            return "^9051[0-9]{0,12}$"
        default:
            return ""
        }
    }
    
    public func possibleTypeFrom(_ cardNumber: String) -> CreditCardType {
        let temp = cardNumber.replacingOccurrences(of: seporator, with: "")
        for type in allTypes {
            let predicate = NSPredicate(format: "SELF MATCHES %@", HSCreditCardValidator.regExpFor(type))
            if predicate.evaluate(with: temp) {
                return type
            }
        }
        return .Unknown
    }
}
