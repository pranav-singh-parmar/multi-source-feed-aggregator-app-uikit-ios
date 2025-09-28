//
//  PostImageRepositoryTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostImageRepositoryTests: XCTestCase {

    func testGetImagesReturnsImagesOnSuccess() {
        let mockPostImages = [PostImageModel.getTestModelOne]
        let mockAPI = MockPostImageAPIDataSource()
        mockAPI.result = .success(mockPostImages)
        
        let repository: PostImageRepository = PostImageRepositoryIMPL(apiDS: mockAPI)
        let expectation = XCTestExpectation(description: "getImages completes")
        
        repository.getImages { result in
            switch result {
            case .success(let postImages):
                XCTAssertEqual(postImages.count, 1)
                XCTAssertEqual(postImages.first?.id, PostImageModel.getTestModelOneID)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetImagesReturnsFailureOnDataSourceError() {
        let mockError = DataSourceError.apiRequestError(.serverError(statusCode: 500), nil)
        let mockAPI = MockPostImageAPIDataSource()
        mockAPI.result = .failure(mockError)
        
        let repository: PostImageRepository = PostImageRepositoryIMPL(apiDS: mockAPI)
        let expectation = XCTestExpectation(description: "getImages completes")
        
        repository.getImages { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                switch error {
                case .dataSourceError(let dataSourceError):
                    switch dataSourceError {
                    case .apiRequestError(let error, let message):
                        switch error {
                        case .serverError(let statusCode):
                            XCTAssertEqual(statusCode, 500)
                        default:
                            XCTFail("Expected serverError")
                        }
                        XCTAssertEqual(message, nil)
                    default:
                        XCTFail("Expected apiRequestError")
                    }
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
