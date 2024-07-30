//
//  APIService.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 25/07/24.
//

import Foundation

struct APIService {
//    let baseURL: String = "https://jsonplaceholder.typicode.com"
    let baseURL: String = "https://d9396b30-7ac7-4839-80f9-ba304a95f9dc.mock.pstmn.io"
//    let baseURL: String = "http://localhost:3001" // Use this for Mockoon local server

    var method: NetworkManager.HTTPMethod = .GET
    
    var path: String = ""
    
    var headers: [String: Any]? = [:]
    
    var params: [String: Any]? = [:]
    
    var parameterEncoding: NetworkManager.EncodingType = .json
}
