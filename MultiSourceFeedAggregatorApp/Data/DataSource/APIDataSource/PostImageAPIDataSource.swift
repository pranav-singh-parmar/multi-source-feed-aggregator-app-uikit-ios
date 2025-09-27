//
//  PostImageAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

class PostImageAPIDataSource: PostImageDataSourceProtocol {
    func getImages(completion:  @escaping (DataSourceResult<[PostImageModel]>) -> Void) {
        do {
            var urlRequest = try URLRequest(ofHTTPMethod: .get, forAppEndpoint: .posts)
            urlRequest.requestResponse(in: .json)
            
            urlRequest.sendAPIRequest { [weak self] result in
                guard self != nil else { return }
                
                switch result {
                case .success(_, let data):
                    if let images = data.toStruct([PostImageModel].self) {
                        completion(.success(images))
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
