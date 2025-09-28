//
//  UserDefault.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    var container: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get {
            if let decodableType = Value.self as? Decodable.Type,
               let data = container.data(forKey: key) {
                do {
                    let data = try JSONDecoder().decode(decodableType, from: data)
                    return data as? Value
                } catch {
                    print("error in \(#function)", error.localizedDescription)
                }
            } else {
                return container.object(forKey: key) as? Value
            }
            return nil
        }
        set {
            if let data = (newValue as? Encodable)?.toData() {
                container.set(data, forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
        }
    }
}
