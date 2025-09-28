//
//  MockRequestSender.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

final class MockRequestSender: RequestSender {
    var result: APIRequestResult<Data, APIRequestError>!
    
    func send(_ request: URLRequest, completion: @escaping (APIRequestResult<Data, APIRequestError>) -> Void) {
        completion(result)
    }
}
