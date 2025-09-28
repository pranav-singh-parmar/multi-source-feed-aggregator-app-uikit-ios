//
//  PostImageModelTestExntesion.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

@testable import MultiSourceFeedAggregatorApp
import Foundation

extension PostImageModel {
    static let getTestModelOneID: Int = 1
    static var getTestModelOne: Self {
        return PostImageModel(
            albumID: 1,
            id: 1,
            title: "Test Title",
            url: "URL Request",
            thumbnailURL: "Image URL"
        )
    }
}
