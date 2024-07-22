//
//  CodableManager.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 24/06/24.
//

import Foundation

public class CodableManager {
    
    static let shared = CodableManager()
    private init() {}
    
    // Encode a Codable object to Data
    func encode<T: Encodable>(_ object: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Adjust formatting as needed
        return try encoder.encode(object)
    }
    
    // Decode Data to a Decodable object
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
