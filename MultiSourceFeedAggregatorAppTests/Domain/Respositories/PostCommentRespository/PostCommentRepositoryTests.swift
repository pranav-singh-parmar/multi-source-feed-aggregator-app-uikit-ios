//
//  PostCommentRepositoryTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostCommentRepositoryTests: XCTestCase {

    func testGetCommentsReturnsCommentsOnSuccess() {
        let mockPostComments = [PostCommentModel.getTestModelOne]
        let mockAPI = MockPostCommentAPIDataSource()
        mockAPI.result = .success(mockPostComments)
        
        let repository: PostCommentRepository = PostCommentRepositoryIMPL(apiDS: mockAPI)
        let expectation = XCTestExpectation(description: "getComments completes")
        
        repository.getComments { result in
            switch result {
            case .success(let comments):
                XCTAssertEqual(comments.data.count, 1)
                XCTAssertEqual(comments.data.first?.id, PostCommentModel.getTestModelOneID)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetCommentsReturnsFailureOnDataSourceError() {
        let mockError = APIDataSourceError.apiRequestError(.serverError(statusCode: 500), nil)
        let mockAPI = MockPostCommentAPIDataSource()
        mockAPI.result = .failure(mockError)
        
        let repository: PostCommentRepository = PostCommentRepositoryIMPL(apiDS: mockAPI)
        let expectation = XCTestExpectation(description: "getComments completes")
        
        repository.getComments { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                switch error {
                case .apiDataSourceError(let apiDataSourceError):
                    switch apiDataSourceError {
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
    
    func testGetCommentsReturnsCachedCommentsWhenNoInternet() {
        let mockCachedComments = [PostCommentModel.getTestModelOne]
        let apiError = APIDataSourceError.apiRequestError(.internetNotConnected, nil)
        
        let mockAPI = MockPostCommentAPIDataSource()
        mockAPI.result = .failure(apiError)
        
        let mockCache = MockPostCommentCacheDataSource()
        mockCache.cachedPostComments = mockCachedComments
        
        let repository: PostCommentRepository = PostCommentRepositoryIMPL(apiDS: mockAPI, cacheDS: mockCache)
        let expectation = XCTestExpectation(description: "getComments completes")
        
        repository.getComments { result in
            switch result {
            case .success(let repositorySuccess):
                XCTAssertEqual(repositorySuccess.data.count, 1)
                XCTAssertEqual(repositorySuccess.data.first?.id, PostCommentModel.getTestModelOneID)
                XCTAssertTrue(repositorySuccess.isFromCache)
            case .failure:
                XCTFail("Expected success from cache, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetImagesReturnsFailureWhenNoInternetAndNoCache() {
        let apiError = APIDataSourceError.apiRequestError(.internetNotConnected, nil)
        
        let mockAPI = MockPostCommentAPIDataSource()
        mockAPI.result = .failure(apiError)
        
        let mockCache = MockPostCommentCacheDataSource()
        mockCache.cachedPostComments = []
        
        let repository: PostCommentRepository = PostCommentRepositoryIMPL(apiDS: mockAPI, cacheDS: mockCache)
        let expectation = XCTestExpectation(description: "getComments completes")
        
        repository.getComments { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                switch error {
                case .apiDataSourceError(let apiDataSourceError):
                    XCTAssertEqual(apiDataSourceError.localizedDescription, apiError.localizedDescription)
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
