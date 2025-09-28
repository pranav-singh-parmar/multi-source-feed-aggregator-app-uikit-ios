//
//  PostModelExtension.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

extension PostModel {
    static let getTestModelOneID: Int = 1
    static var getTestModelOne: Self {
        return PostModel(
            userID: 1,
            id: getTestModelOneID,
            title: "Test Title",
            body: "Test Body"
        )
    }
    
    static let getTestModelTwoID: Int = 2
    static var getTestModelTwo: Self {
        return PostModel(
            userID: 2,
            id: 2,
            title: "Test Title 2",
            body: "Test Body 2"
        )
    }
}
