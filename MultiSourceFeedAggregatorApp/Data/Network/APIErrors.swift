//
//  APIErrors.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

//MARK: - Error Enums
enum URLRequestError: Error {
    case invalidURL,
         invalidQueryParameters
}

enum ClientErrorsEnum {
    case badRequest,//400
         unauthorised,//401
         paymentRequired,//402
         forbidden,//403
         notFound,//404
         methodNotAllowed,//405
         notAcceptable,//406
         uriTooLong,//414
         other(Int)
    
    static func getCorrespondingValue(forStatusCode statusCode: Int) -> ClientErrorsEnum {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorised
        case 402:
            return .paymentRequired
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 406:
            return .notAcceptable
        case 414:
            return .uriTooLong
        default:
            return .other(statusCode)
        }
    }
}

//https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses
//Informational responses (100-199)
//Successful responses (200–299)
//Redirection messages (300–399)
//Client error responses (400–499)
//Server error responses (500–599)
enum APIRequestError: Error {
    case internetNotConnected,
         invalidHTTPURLResponse,
         timedOut,
         networkConnectionLost,
         urlError(errorCode: Int),
         missingMimeType,
         mimeTypeMismatched,
         informationalError(statusCode: Int),
         redirectionError(statusCode: Int),
         clientError(ClientErrorsEnum),
         serverError(statusCode: Int),
         unknown(statusCode: Int)
}
