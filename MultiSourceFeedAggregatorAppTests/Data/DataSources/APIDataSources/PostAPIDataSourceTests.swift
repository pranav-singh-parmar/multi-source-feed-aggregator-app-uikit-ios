//
//  PostAPIDataSourceTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostAPIDataSourceTests: XCTestCase {

    func testGetPostsReturnsPostsOnSuccess() {
        let mockPosts = [PostModel.getTestModelOne]
        let mockData = try! JSONEncoder().encode(mockPosts)
        
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 200, mockData)
        
        let dataSource = PostAPIDataSourceIMPL(sender: mockSender)
        let expectation = XCTestExpectation(description: "getPosts completes")
        
        dataSource.getPosts { result in
            switch result {
            case .success(let posts):
                XCTAssertEqual(posts.count, 1)
                XCTAssertEqual(posts.first?.id, PostModel.getTestModelOneID)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetPostsReturnsDecodingErrorOnInvalidData() {
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 500, Data("Server Error".utf8))
        
        let dataSource = PostAPIDataSourceIMPL(sender: mockSender)
        let expectation = XCTestExpectation(description: "getPosts completes")
        
        dataSource.getPosts { result in
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
