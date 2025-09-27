//
//  PostAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostAPIDataSource: PostDataSourceProtocol {
    func getPosts(completion:  @escaping (DataSourceResult<[PostModel]>) -> Void) {
        do {
            var urlRequest = try URLRequest(ofHTTPMethod: .get, forAppEndpoint: .posts)
            urlRequest.requestResponse(in: .json)
            
            urlRequest.sendAPIRequest { [weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .success(_, let data):
                    if let posts = data.toStruct([PostModel].self) {
                        completion(.success(posts))
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
