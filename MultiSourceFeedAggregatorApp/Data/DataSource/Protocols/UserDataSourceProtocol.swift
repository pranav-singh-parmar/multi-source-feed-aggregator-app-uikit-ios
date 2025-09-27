//
//  UserDataSourceProtocol 2.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 27/09/25.
//


import Foundation

protocol UserDataSourceProtocol {
    func getUsers(completion: @escaping (DataSourceResult<[UserModel]>) -> Void)
}
