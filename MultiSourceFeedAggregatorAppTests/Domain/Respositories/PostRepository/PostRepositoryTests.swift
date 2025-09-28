//
//  PostRepositoryTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostRepositoryTests: XCTestCase {

    func testGetPostsReturnsPostsOnSuccess() {
        let mockPosts = [PostModel.getTestModelOne]
        let mockAPI = MockPostAPIDataSource()
        mockAPI.result = .success(mockPosts)
        
        let repository: PostRepository = PostRepositoryIMPL(apiDS: mockAPI)
        let expectation = XCTestExpectation(description: "getPosts completes")
        
        repository.getPosts { result in
            switch result {
            case .success(let posts):
                XCTAssertEqual(posts.data.count, 1)
                XCTAssertEqual(posts.data.first?.id, PostModel.getTestModelOneID)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetPostsReturnsFailureOnDataSourceError() {
        let mockError = APIDataSourceError.apiRequestError(.serverError(statusCode: 500), nil)
        let mockAPI = MockPostAPIDataSource()
        mockAPI.result = .failure(mockError)
        
        let repository: PostRepository = PostRepositoryIMPL(apiDS: mockAPI)
        let expectation = XCTestExpectation(description: "getPosts completes")
        
        repository.getPosts { result in
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
    
    func testGetPostsReturnsCachedPostsWhenNoInternet() {
        let mockCachedPosts = [PostModel.getTestModelOne]
        let apiError = APIDataSourceError.apiRequestError(.internetNotConnected, nil)
        
        let mockAPI = MockPostAPIDataSource()
        mockAPI.result = .failure(apiError)
        
        let mockCache = MockPostCacheDataSource()
        mockCache.cachedPosts = mockCachedPosts
        
        let repository: PostRepository = PostRepositoryIMPL(apiDS: mockAPI, cacheDS: mockCache)
        let expectation = XCTestExpectation(description: "getPosts completes")
        
        repository.getPosts { result in
            switch result {
            case .success(let repositorySuccess):
                XCTAssertEqual(repositorySuccess.data.count, 1)
                XCTAssertEqual(repositorySuccess.data.first?.id, PostModel.getTestModelOneID)
                XCTAssertTrue(repositorySuccess.isFromCache)
            case .failure:
                XCTFail("Expected success from cache, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetPostsReturnsFailureWhenNoInternetAndNoCache() {
        let apiError = APIDataSourceError.apiRequestError(.internetNotConnected, nil)
        
        let mockAPI = MockPostAPIDataSource()
        mockAPI.result = .failure(apiError)
        
        let mockCache = MockPostCacheDataSource()
        mockCache.cachedPosts = []
        
        let repository: PostRepository = PostRepositoryIMPL(apiDS: mockAPI, cacheDS: mockCache)
        let expectation = XCTestExpectation(description: "getPosts completes")
        
        repository.getPosts { result in
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
