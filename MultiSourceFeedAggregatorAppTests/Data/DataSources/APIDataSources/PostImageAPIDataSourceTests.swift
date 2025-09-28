//
//  PostImageAPIDataSourceTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostImageAPIDataSourceTests: XCTestCase {

    func testGetPostImagesReturnsPostImagesOnSuccess() {
        let mockPostImages = [PostImageModel.getTestModelOne]
        let mockData = mockPostImages.toData() ?? Data()
        
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 200, mockData)
        
        let dataSource = PostImageAPIDataSourceIMPL(sender: mockSender)
        let expectation = XCTestExpectation(description: "getImages completes")
        
        dataSource.getImages { result in
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
    
    func testGetPostImagesReturnsDecodingErrorOnInvalidData() {
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 500, Data("Server Error".utf8))
        
        let dataSource = PostImageAPIDataSourceIMPL(sender: mockSender)
        let expectation = XCTestExpectation(description: "getImages completes")
        
        dataSource.getImages { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                if case .decodingError = error {
                    XCTAssertTrue(true)
                } else {
                    XCTFail("Expected decodingError")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
