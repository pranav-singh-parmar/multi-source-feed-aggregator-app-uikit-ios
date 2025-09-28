//
//  UserRepositoryTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class UserRepositoryTests: XCTestCase {

    func testGetUsersReturnsUsersOnSuccess() {
        let mockUsers = [UserModel.getTestModelOne]
        let mockAPI = MockUserAPIDataSource()
        mockAPI.result = .success(mockUsers)
        
        let repository: UserRepository = UserRepositoryIMPL(apiDS: mockAPI)
        let expectation = XCTestExpectation(description: "getUsers completes")
        
        repository.getUsers { result in
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
    
    func testGetUsersReturnsFailureOnDataSourceError() {
        let mockError = APIDataSourceError.apiRequestError(.serverError(statusCode: 500), nil)
        let mockAPI = MockUserAPIDataSource()
        mockAPI.result = .failure(mockError)
        
        let repository: UserRepository = UserRepositoryIMPL(apiDS: mockAPI)
        let expectation = XCTestExpectation(description: "getUsers completes")
        
        repository.getUsers { result in
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
                default:
                    XCTFail("Expected apiDataSourceError")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
