//
//  NetworkError.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang-M1Pro on 05/08/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case invalidParameters
    case errorResponse(error: ResponseError)
    case genericError(error: Error)

    var errorMessage: String {
        switch self {
        case .errorResponse(let error):
            return error.message ?? ""
        default:
            return ""
        }
    }
}
