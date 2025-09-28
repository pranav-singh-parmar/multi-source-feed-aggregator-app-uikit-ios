//
//  URLRequestSender.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

//MARK: - URLRequestSender
class URLRequestSender: RequestSender {
    func send(_ request: URLRequest, completion: @escaping (APIRequestResult<Data, APIRequestError>) -> Void) {
        
#if DEBUG
        request.printHeaders()
        request.printRequestDetailsTag(isStarted: false)
        request.printLogs()
#endif
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
#if DEBUG
            request.printResponseDetailsTag(isStarted: true)
            defer {
                request.printLogs()
            }
#endif
            
            guard error == nil else {
#if DEBUG
                request.addLog("Error Localised Description:", error!.localizedDescription)
#endif
                let errorCode = (error! as NSError).code
                switch errorCode {
                case NSURLErrorTimedOut:
                    completion(.failure(request.printAndReturnAPIRequestError(.timedOut), data))
                    return
                case NSURLErrorNotConnectedToInternet:
                    completion(.failure(request.printAndReturnAPIRequestError(.internetNotConnected), data))
                    return
                case NSURLErrorNetworkConnectionLost:
                    completion(.failure(request.printAndReturnAPIRequestError(.networkConnectionLost), data))
                    return
                default:
                    completion(.failure(request.printAndReturnAPIRequestError(.urlError(errorCode: errorCode)), nil))
                    return
                }
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(request.printAndReturnAPIRequestError(.invalidHTTPURLResponse), data))
                return
            }
            
#if DEBUG
            request.addLog("Status Code:", response.statusCode)
#endif
            
            guard let data = data else{
                completion(.failure(request.printAndReturnAPIRequestError(.invalidHTTPURLResponse), data))
                return
            }
            
            guard let mimeType = response.mimeType else {
                completion(.failure(request.printAndReturnAPIRequestError(.missingMimeType), data))
                return
            }
            
            if let accept = request.getHeaderValue(forKey: "Accept"),
               accept != mimeType {
#if DEBUG
                request.addLog("Wrong MIME type!")
                request.addLog("Accept Key sent in header:", accept)
                request.addLog("MimeType received in Response:", mimeType)
                if let paragraphs = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines) {
                    request.addLog("Data received from API:")
                    for line in paragraphs {
                        request.addLog(line)
                    }
                } else {
                    request.addLog("Default Message: Not able to read data")
                }
#endif
                completion(
                    .failure(
                        request.printAndReturnAPIRequestError(.mimeTypeMismatched),
                        data
                    )
                )
                return
            }
            
#if DEBUG
            do {
                let jsonConvert = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = jsonConvert as? JSONKeyValuePair {
                    request.addLog(json.toJSONStringFormat() ?? "")
                } else if let jsonArray = jsonConvert as? [JSONKeyValuePair] {
                    request.addLog(jsonArray.toJSONStringFormat() ?? "")
                } else {
                    request.addLog("Response is neither Json, nor array of Json")
                }
            } catch {
                print("Can't Fetch JSON Response:", error)
            }
#endif
            
            switch response.statusCode {
            case 100...199:
                completion(
                    .failure(
                        request.printAndReturnAPIRequestError(.informationalError(statusCode: response.statusCode)),
                        data
                    )
                )
                return
            case 200...299:
                request.printResponseDetailsTag(isStarted: false)
                completion(
                    .success(statusCode: response.statusCode, data)
                )
                return
            case 300...399:
                completion(
                    .failure(
                        request.printAndReturnAPIRequestError(.redirectionError(statusCode: response.statusCode)),
                        data)
                )
                return
            case 400...499:
                let clientErrorEnum = ClientErrorsEnum.getCorrespondingValue(forStatusCode: response.statusCode)
                completion(
                    .failure(
                        request.printAndReturnAPIRequestError(.clientError(clientErrorEnum)),
                        data)
                )
                return
            case 500...599:
                completion(
                    .failure(
                        request.printAndReturnAPIRequestError(.serverError(statusCode: response.statusCode)),
                        data)
                )
                return
            default:
                completion(
                    .failure(
                        request.printAndReturnAPIRequestError(.unknown(statusCode: response.statusCode)),
                        data)
                )
                return
            }
        }.resume()
    }
}
