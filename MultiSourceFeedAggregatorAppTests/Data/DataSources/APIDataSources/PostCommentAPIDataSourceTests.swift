//
//  PostCommentAPIDataSourceTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class PostCommentAPIDataSourceTests: XCTestCase {

    func testGetCommentsReturnsPostCommentsOnSuccess() {
        let mockPostComments = [PostCommentModel.getTestModelOne]
        let mockData = mockPostComments.toData() ?? Data()
        
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 200, mockData)
        
        let dataSource = PostCommentAPIDataSourceIMPL(sender: mockSender)
        let expectation = XCTestExpectation(description: "getComments completes")
        
        dataSource.getComments { result in
            switch result {
            case .success(let comments):
                XCTAssertEqual(comments.count, 1)
                XCTAssertEqual(comments.first?.id, PostCommentModel.getTestModelOneID)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetPostCommentsReturnsDecodingErrorOnInvalidData() {
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 500, Data("Server Error".utf8))
        
        let dataSource = PostCommentAPIDataSourceIMPL(sender: mockSender)
        let expectation = XCTestExpectation(description: "getComments completes")
        
        dataSource.getComments { result in
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
