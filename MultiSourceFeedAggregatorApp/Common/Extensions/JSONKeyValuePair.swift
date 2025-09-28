//
//  JSONKeyValuePair.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

typealias JSONKeyValuePair = [String: Any]

extension JSONKeyValuePair {
    func toJSONStringFormat() -> String? {
        do {
            // Serialize to JSON
            let jsonData = try JSONSerialization.data(withJSONObject: self,
                                                      options: [.prettyPrinted, .withoutEscapingSlashes])
            
            // Convert to a string and print
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            }
            print("Could not convert to string")
        } catch {
            print("Could not print parameters, Error -> \(error)")
        }
        return nil
    }
    
    func toStruct<T: Decodable>(_ decodingModel: T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let model = jsonData.toStruct(decodingModel)
            return model
        } catch {
            print("decoding error", error.localizedDescription)
        }
        return nil
    }
    
    var getErrorMessage: String {
        if let message = self["message"] as? String {
            return message
        } else if let error = self["error"] as? String {
            return error
        } else if let errorMessages = self["error"] as? [String] {
            var error = ""
            for message in errorMessages {
                if error != "" {
                    error = error + ", "
                }
                error = error + message
            }
            return error
        }
        return "Server Error"
    }
}

extension Array where Element == JSONKeyValuePair {
    func toJSONStringFormat() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .withoutEscapingSlashes])
            // Convert to a string and print
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            }
            print("Could not convert to string")
        } catch {
            print("Could not print parameters, Error -> \(error)")
        }
        return nil
    }
}

//MARK: - Data
extension Data {
    var toJSONKeyValuePair: JSONKeyValuePair? {
        do {
            let jsonConvert = try JSONSerialization.jsonObject(with: self, options: [])
            if let json = jsonConvert as? JSONKeyValuePair {
                return json
            }
        } catch {
            print("Can't Get JSON Response:", error)
        }
        return nil
    }
    
    func getErrorMessageFromJSONData(withAPIRequestError apiRequestError: APIRequestError) -> String? {
        let errorMessage: String?
        if let json = self.toJSONKeyValuePair {
            switch apiRequestError {
                //            case .internetNotConnected:
                //                errorMessage = "Check your Internet Connection"
                //            case .invalidHTTPURLResponse:
                //                errorMessage = "Invalid Response"
                //            case .timedOut:
                //                errorMessage = "Server Request timed out"
                //            case .networkConnectionLost:
                //                errorMessage = "Connection with Server lost"
                //            case .urlError(_):
                //                errorMessage = "URL not initialised"
                //            case .invalidMimeType:
                //                errorMessage = "Invalid response from Server"
            case .clientError(let clientErrorEnum):
                switch clientErrorEnum {
                case .unauthorised:
                    errorMessage = json.getErrorMessage
                case .badRequest, .paymentRequired, .forbidden, .notFound, .methodNotAllowed, .notAcceptable, .uriTooLong, .other:
                    errorMessage = json.getErrorMessage
                }
            case .informationalError(_), .redirectionError(_), .serverError(_), .unknown(_):
                errorMessage = json.getErrorMessage
            default:
                errorMessage = nil
            }
        } else {
            errorMessage = nil
        }
        return errorMessage
    }
}
