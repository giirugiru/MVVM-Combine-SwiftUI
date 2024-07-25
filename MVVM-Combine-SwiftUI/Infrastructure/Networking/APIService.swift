//
//  APIService.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 25/07/24.
//

import Foundation

struct APIService {
    let baseURL: String = "https://jsonplaceholder.typicode.com"

    var method: NetworkManager.HTTPMethod = .GET
    
    var path: String = ""
    
    var headers: [String: Any]? = [:]
    
    var params: [String: Any]? = [:]
    
    var parameterEncoding: NetworkManager.EncodingType = .json
}
