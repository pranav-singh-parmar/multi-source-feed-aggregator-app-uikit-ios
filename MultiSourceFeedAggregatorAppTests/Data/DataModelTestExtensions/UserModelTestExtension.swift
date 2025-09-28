//
//  UserModelTestExtension.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

extension UserModel {
    static let getTestModelOneID: Int = 1
    static var getTestModelOne: Self {
        return UserModel(
            id: 1,
            name: "Test Name",
            username: "Test Username",
            email: "Test Email",
            address: nil,
            phone: "Test Phone",
            website: "TestWebsite",
            company: nil
        )
    }
    
    static let getTestModelTwoID: Int = 2
    static var getTestModelTwo: Self {
        return UserModel(
            id: 2,
            name: "Test Name 2",
            username: "Test Username 2",
            email: "Test Email 2",
            address: nil,
            phone: "Test Phone 2",
            website: "TestWebsite 2",
            company: nil
        )
    }
}
