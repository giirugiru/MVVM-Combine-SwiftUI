//
//  BaseResponse.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Achmad Fauzan on 28/07/2024.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    public let payload: T?
    public let errors: ResponseError?
    public let timeStamp: String?
    public let success: Bool?
}

struct ResponseError: Codable {
    public let code: String?
    public let message: String?
}

extension Error {
    func toResponseError() -> NetworkError {
        if let responseError = self as? NetworkError {
            return responseError
        } else {
            return .genericError(error: self)
        }
    }
}
