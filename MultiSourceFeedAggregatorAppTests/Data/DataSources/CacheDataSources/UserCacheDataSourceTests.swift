//
//  UserCacheDataSourceTests.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 29/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import XCTest

final class UserCacheDataSourceTests: XCTestCase {

    private var cacheDS: UserCacheDataSourceIMPL!
    
    override func setUp() {
        super.setUp()
        cacheDS = UserCacheDataSourceIMPL()
        UserDefaults.cachedUsers = nil
    }
    
    override func tearDown() {
        UserDefaults.cachedUsers = nil
        cacheDS = nil
        super.tearDown()
    }

    func testSaveCommentsStoresComments() {
        let users = [UserModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "saveUsers completes")
        
        cacheDS.saveUsers(users) { success in
            XCTAssertTrue(success)
            XCTAssertEqual(UserDefaults.cachedUsers?.count, 1)
            XCTAssertEqual(UserDefaults.cachedUsers?.first?.id, UserModel.getTestModelOneID)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetUsersReturnsStoredUsers() {
        UserDefaults.cachedUsers = [UserModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "getUsers completes")
        
        cacheDS.getUsers { users in
            XCTAssertNotNil(users)
            XCTAssertEqual(users?.count, 1)
            XCTAssertEqual(users?.first?.id, UserModel.getTestModelOneID)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetUsersReturnsNilIfNoUsers() {
        UserDefaults.cachedUsers = nil
        let expectation = XCTestExpectation(description: "getUsers completes")
        
        cacheDS.getUsers { users in
            XCTAssertNil(users)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testClearRemovesUsers() {
        UserDefaults.cachedUsers = [UserModel.getTestModelOne]
        let expectation = XCTestExpectation(description: "clear completes")
        
        cacheDS.clear {
            XCTAssertNil(UserDefaults.cachedUsers)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
