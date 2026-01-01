//
//  Decode+data+mismatch.swift
//  SabaideaTask
//
//  Created by Erfan mac mini on 12/12/24.
//

import Foundation

enum convertDataToJSONObjectError: Error {
    case dataCorrupted
}

public extension Data {
    func convertDataToJSONObject() throws -> Data {
        if let jsonObject = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
            // Convert JSON object back to Data
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return jsonData
        }
        throw convertDataToJSONObjectError.dataCorrupted
    }

    func decode<T: Decodable>() throws -> T {
        var errorMessage: String = ""
        
        do {
            let result = try JSONDecoder().decode(T.self, from: self)
            return result
        } catch let DecodingError.dataCorrupted(context) {
            errorMessage = "\(context)"

        } catch let DecodingError.keyNotFound(key, context) {
            errorMessage = "Key '\(key)' not found: " + context.debugDescription
            errorMessage += "\n codingPath: \(context.codingPath)"
            
        } catch let DecodingError.valueNotFound(value, context) {
            errorMessage = "value '\(value)' not found: " + context.debugDescription
            errorMessage += "\n codingPath: \(context.codingPath)"

        } catch let DecodingError.typeMismatch(type, context)  {
            errorMessage = "Type '\(type)' mismatch: " + context.debugDescription
            errorMessage += "\n codingPath: \(context.codingPath)"

        } catch {
            errorMessage = error.localizedDescription
            
        }
        throw CustomError(description: errorMessage)
    }
    
    func toJson() throws -> Any {
         try JSONSerialization.jsonObject(with: self, options: [])
    }
}
