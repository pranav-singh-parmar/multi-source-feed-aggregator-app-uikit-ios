//
//  URLRequestExtension.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation
import os

extension URLRequest {
    //MARK: - Logs Related
#if DEBUG
    private static let apiErrorTAG = "APIError:"
    
    private static let logger = Logger.init(subsystem: Bundle.main.getBundleIdentifier ?? "", category: "ApiServices")
    //log related
    private static var logs: [String: String] = [:]
    
    func addLog(_ logs: Any...) {
        var logString = (URLRequest.logs[getURLString] ?? "") + "\n"
        logString += logs.map { "\($0)" }.joined(separator: " ")
        URLRequest.logs[getURLString] = logString
    }
    
    func printLogs() {
        let str = URLRequest.logs[getURLString] ?? ""
        // print(URLRequest.logs[getURLString] ?? "")
        URLRequest.logger.log(level: .default, "\(str)")
        URLRequest.logs.removeValue(forKey: getURLString)
    }
#endif
    
    //MARK: - Computed vars
    var getURLString: String {
        //logs.info("URLGOT")
        return self.url?.absoluteString ?? "URL not set"
    }
    
    //MARK: - Initialisers
    init(ofHTTPMethod httpMethod: HTTPMethod,
         forAppEndpoint appEndpoint: AppEndpoints,
         withQueryParameters queryParameters: JSONKeyValuePair? = nil) throws(URLRequestError) {
        do {
            try self.init(ofHTTPMethod: httpMethod,
                          forEndpoint: appEndpoint,
                          withQueryParameters: queryParameters)
        } catch {
            throw error
        }
    }
    
    private init(ofHTTPMethod httpMethod: HTTPMethod,
                 forEndpoint apiEndpoint: APIEndpointsProtocol,
                 withQueryParameters queryParameters: JSONKeyValuePair? = nil) throws(URLRequestError) {
        do {
            try self.init(ofHTTPMethod: httpMethod,
                          urlString: apiEndpoint.getURLString,
                          withQueryParameters: queryParameters)
        } catch {
            throw error
        }
    }
    
    init(ofHTTPMethod httpMethod: HTTPMethod,
         urlString: String,
         withQueryParameters queryParameters: JSONKeyValuePair? = nil) throws(URLRequestError) {
        guard let url = URL(string: urlString) else {
            print(URLRequest.apiErrorTAG, "Cannot Initiate URL with String", urlString)
            throw .invalidURL
        }
        
        self.init(url: url)
        if let queryParameters {
            let urlComponents = getURLComponents(withQueryParameters: queryParameters)
            guard let url = urlComponents?.url else {
                throw .invalidQueryParameters
            }
            
            self.url = url
            
#if DEBUG
            printRequestDetailsTag(isStarted: true)
            addLog("Query Parameters:")
            addLog(queryParameters.toJSONStringFormat() ?? "")
            addLog("URL with Query Parameter:", self.getURLString)
#endif
        } else {
#if DEBUG
            printRequestDetailsTag(isStarted: true)
#endif
        }
        self.httpMethod = httpMethod.rawValue
#if DEBUG
        addLog("HTTP Method:", self.httpMethod ?? "http method not assigned")
#endif
    }
    
    //MARK: - URLComponents
    private func getURLComponents(withQueryParameters queryParameters: JSONKeyValuePair) -> URLComponents? {
        var urlComponents = URLComponents(string: self.getURLString)
        urlComponents?.queryItems = []
        for (key, value) in queryParameters {
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
        if let component = urlComponents {
            //https://stackoverflow.com/questions/27723912/swift-get-request-with-parameters
            //this code is added because some servers interpret '+' as space because of x-www-form-urlencoded specification
            //so we have to percent escape it manually because URLComponents does not perform it
            //space is percent encoded as %20 and '+' is encoded as "%2B"
            urlComponents?.percentEncodedQuery = component.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        return urlComponents
    }
    
    //MARK: - Headers
    mutating func addHeader(withKey key: String, andValue value: String) {
        self.addValue(value, forHTTPHeaderField: key)
    }
    
    mutating func requestResponse(in mimeType: MimeTypeEnum) {
        self.addHeader(withKey: "Accept", andValue: mimeType.rawValue)
    }
    
    func getHeaderValue(forKey key: String) -> String? {
        return self.allHTTPHeaderFields?.first(where: { $0.key == key })?.value
    }
    
    //MARK: - Print and return API error
    func printAndReturnAPIRequestError(_ apiError: APIRequestError) -> APIRequestError {
        #if DEBUG
        printApiError(apiError)
        #endif
        return apiError
    }
    
    //MARK: - Print Related Functions
    func printHeaders() {
#if DEBUG
        addLog("Headers:")
        addLog((self.allHTTPHeaderFields as JSONKeyValuePair?)?.toJSONStringFormat() ?? "")
#endif
    }
    
    func printApiError(_ apiError: APIRequestError) {
#if DEBUG
        addLog(URLRequest.apiErrorTAG, "\(apiError)")
        printResponseDetailsTag(isStarted: false)
#endif
    }
    
    func printRequestDetailsTag(isStarted: Bool) {
#if DEBUG
        if isStarted {
            addLog("-----URL Request Details Starts-----")
            addLog("URL:", self.getURLString)
        } else {
            addLog("-----URL Request Details Ends-----\n")
        }
#endif
    }
    
    func printResponseDetailsTag(isStarted: Bool) {
#if DEBUG
        if isStarted {
            addLog("-----URL Response Details Starts-----")
            addLog("URL:", self.getURLString)
        } else {
            addLog("-----URL Response Details Ends-----\n")
        }
#endif
    }
}
