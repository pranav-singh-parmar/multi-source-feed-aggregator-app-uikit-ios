//
//  PostCommentAPIDataSourceIMPL.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostCommentAPIDataSourceIMPL: PostCommentAPIDataSource {
    
    private let sender: RequestSender
        
    init(sender: RequestSender = URLRequestSender()) {
        self.sender = sender
    }
    
    func getComments(completion:  @escaping (APIDataSourceResult<[PostCommentModel]>) -> Void) {
        do {
            var urlRequest = try URLRequest(ofHTTPMethod: .get, forAppEndpoint: .comments)
            urlRequest.requestResponse(in: .json)
            
            sender.send(urlRequest) { [weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .success(_, let data):
                    if let comments = data.toStruct([PostCommentModel].self) {
                        completion(.success(comments))
                    } else {
                        completion(.failure(.decodingError))
                    }
                case .failure(let error, let data):
                    let errorMessage = data?.getErrorMessageFromJSONData(withAPIRequestError: error)
                    completion(.failure(.apiRequestError(error, errorMessage)))
                }
            }
        } catch {
            completion(.failure(.urlRequestError(error)))
        }
    }
}
