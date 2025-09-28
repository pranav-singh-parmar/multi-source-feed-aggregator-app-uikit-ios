//
//  RequestSender.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

protocol RequestSender {
    func send(_ request: URLRequest, completion: @escaping (APIRequestResult<Data, APIRequestError>) -> Void)
}
