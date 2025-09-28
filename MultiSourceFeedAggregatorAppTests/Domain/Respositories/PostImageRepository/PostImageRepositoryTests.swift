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
                XCTAssertEqual(postImages.data.count, 1)
                XCTAssertEqual(postImages.data.first?.id, PostImageModel.getTestModelOneID)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetImagesReturnsFailureOnDataSourceError() {
        let mockError = APIDataSourceError.apiRequestError(.serverError(statusCode: 500), nil)
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
    
    func testGetImagesReturnsCachedImagesWhenNoInternet() {
        let mockCachedPostImage = [PostImageModel.getTestModelOne]
        let apiError = APIDataSourceError.apiRequestError(.internetNotConnected, nil)
        
        let mockAPI = MockPostImageAPIDataSource()
        mockAPI.result = .failure(apiError)
        
        let mockCache = MockPostImageCacheDataSource()
        mockCache.cachedPostImages = mockCachedPostImage
        
        let repository: PostImageRepository = PostImageRepositoryIMPL(apiDS: mockAPI, cacheDS: mockCache)
        let expectation = XCTestExpectation(description: "getImages completes")
        
        repository.getImages { result in
            switch result {
            case .success(let repositorySuccess):
                XCTAssertEqual(repositorySuccess.data.count, 1)
                XCTAssertEqual(repositorySuccess.data.first?.id, PostImageModel.getTestModelOneID)
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
        
        let mockAPI = MockPostImageAPIDataSource()
        mockAPI.result = .failure(apiError)
        
        let mockCache = MockPostImageCacheDataSource()
        mockCache.cachedPostImages = []
        
        let repository: PostImageRepository = PostImageRepositoryIMPL(apiDS: mockAPI, cacheDS: mockCache)
        let expectation = XCTestExpectation(description: "getImages completes")
        
        repository.getImages { result in
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
