//
//  UserModel.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let id: Int?
    let name, username, email: String?
    let address: UserAddressModel?
    let phone, website: String?
    let company: UserCompanyModel?
}

// MARK: - UserAddressModel
struct UserAddressModel: Codable {
    let street, suite, city, zipcode: String?
    let geo: UserAddressGeoModel?
    
    var completeAddress: String {
        let parts = [street, suite, city, zipcode]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        return parts.joined(separator: ", ")
    }
}

// MARK: - UserAddressGeoModel
struct UserAddressGeoModel: Codable {
    let lat, lng: String?
}

// MARK: - UserCompanyModel
struct UserCompanyModel: Codable {
    let name, catchPhrase, bs: String?
}
