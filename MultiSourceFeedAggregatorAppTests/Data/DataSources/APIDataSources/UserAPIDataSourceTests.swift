//
//  UserAPIDataSourceTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class UserAPIDataSourceTests: XCTestCase {

    func testGetUsersReturnsUsersOnSuccess() {
        let mockUsers = [UserModel.getTestModelOne]
        let mockData = mockUsers.toData() ?? Data()
        
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 200, mockData)
        
        let dataSource = UserAPIDataSourceIMPL(sender: mockSender)
        let expectation = XCTestExpectation(description: "getUsers completes")
        
        dataSource.getUsers { result in
            switch result {
            case .success(let users):
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.id, UserModel.getTestModelOneID)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetUsersReturnsDecodingErrorOnInvalidData() {
        let mockSender = MockRequestSender()
        mockSender.result = .success(statusCode: 500, Data("Server Error".utf8))
        
        let dataSource = UserAPIDataSourceIMPL(sender: mockSender)
        let expectation = XCTestExpectation(description: "getUsers completes")
        
        dataSource.getUsers { result in
            // Assert
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
