//
//  Codable+Ext.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Achmad Fauzan on 11/08/2024.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dictionary
    }
}
