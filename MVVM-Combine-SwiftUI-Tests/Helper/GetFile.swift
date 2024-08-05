//
//  GetFile.swift
//  MVVM-Combine-SwiftUI-Tests
//
//  Created by Achmad Fauzan on 03/08/2024.
//

import Foundation

class GetFile<T: Codable> {
    func load(fileName: String? = nil) -> T? {
        let bundle = Bundle(for: GetFile.self)
        let filename: String

        if let name = fileName {
          filename = name
        } else {
          filename = String(describing: T.self)
        }

        guard let path = bundle.path(forResource: filename, ofType: "json"),
              let value = try? String(contentsOfFile: path) else {
                return nil
              }

        guard let jsonData = value.data(using: .utf8) else {
            fatalError("Unable to convert JSON string to Data")
        }

        do {
            let codable = try JSONDecoder().decode(T.self, from: jsonData)
            return codable
        } catch {
            return nil
        }
      }

}
