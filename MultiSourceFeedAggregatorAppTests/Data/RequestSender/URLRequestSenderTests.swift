//
//  URLRequestSenderTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class URLRequestSenderTests: XCTestCase {
    func testSendReturnsDataOnSuccess() {
        let mockData = "Hello World".data(using: .utf8)!
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 200, mockData)
        
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let expectation = XCTestExpectation(description: "RequestSender completes")
        
        mockSender.send(request) { result in
            switch result {
            case .success(let statusCode, let data):
                XCTAssertEqual(data, mockData)
                XCTAssertEqual(statusCode, 200)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSendReturnsErrorOnFailure() {
        let mockError = APIRequestError.serverError(statusCode: 500)
        let mockSender = MockRequestSender()
        mockSender.result = .failure(mockError, nil)
        
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let expectation = XCTestExpectation(description: "RequestSender completes")
        
        // Act
        mockSender.send(request) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error, let data):
                switch error {
                case .serverError(let statusCode):
                    XCTAssertEqual(statusCode, 500)
                default:
                    XCTFail("Expected server error failure")
                }
                XCTAssertEqual(data, nil)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
