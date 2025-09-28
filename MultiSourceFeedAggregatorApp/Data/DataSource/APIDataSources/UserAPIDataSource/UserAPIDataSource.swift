//
//  UserAPIDataSource.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//


import Foundation

protocol UserAPIDataSource {
    func getUsers(completion: @escaping (DataSourceResult<[UserModel]>) -> Void)
}
