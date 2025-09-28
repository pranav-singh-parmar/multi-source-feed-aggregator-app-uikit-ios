//
//  Encodable.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

//MARK: - Encodable
extension Encodable {
    func toData() -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return jsonData
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
