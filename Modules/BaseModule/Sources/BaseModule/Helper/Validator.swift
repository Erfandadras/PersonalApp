//
//  Validator.swift
//  realstate
//
//  Created by Erfan mac mini on 11/23/24.
//


import Foundation

public struct Validator {

   public let closure: (String) -> Bool

    public init(validation: @escaping (String) -> Bool) {
        self.closure = validation
    }

    public func validate(value: String?) -> Bool {
        return closure(value ?? "")
    }
}

public extension Validator {
    
    static var website: Validator {
        return Validator {value in
            let websiteRegex = Regex.website
            
            let textRange = NSRange(location: 0, length: value.utf16.count)
            if let match = try? NSRegularExpression(pattern: websiteRegex, options: .caseInsensitive).firstMatch(in: value, options: [], range: textRange) {
                return match.range == textRange
            }
            
            return false
        }
    }
    static var maxLenght: Validator {
        return Validator { value in
            return value.count <= 255
        }
    }

    static var notEmpty: Validator {
        return Validator { value in
            return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
        }
    }

    static var text: Validator {
        return Validator { value in
            return value.count <= 255 && value.count > 0
        }
    }
    
    static var fullName: Validator {
        return Validator { value in
            return value.count <= 50 && value.count > 0
        }
    }

    static var email: Validator {
        return validate(with: Regex.email)
    }
    
    static var phone: Validator {
        return validate(with: Regex.phone)
    }
    
    static func textLimit(min: Int, max: Int?) -> Validator {
         return Validator { value in
             return value.count >= min && (max != nil ? value.count <= max! : true)
         }
     }
    
    static func generateRegex(with pattern: String) -> String {
        // Convert the pattern into a regex
        let regexPattern = pattern
            .replacingOccurrences(of: "#", with: "\\d")  // Replace # with digit placeholder
            .replacingOccurrences(of: " ", with: "\\s") // Replace spaces with space regex
        return "^\(regexPattern)$"
    }
    
    static func validate(with regex: String) -> Validator {
        return Validator { value in
            let regexTest = NSPredicate(format: "SELF MATCHES %@", regex)
            return regexTest.evaluate(with: value)
        }
    }
    
}


public extension Validator {
    struct Regex {
        public static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,5}"
        public static let website = "^(https?://)?([a-zA-Z0-9.-]+)\\.([a-zA-Z]{2,})(/[a-zA-Z0-9-._?&=]*)?$"
        public static let phone = #"^\+\d{1,4}\s?\d{6,14}$"#
        public static let username = "^[a-zA-Z0-9._]{3,20}$"
    }
}
