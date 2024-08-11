//
//  UpdateNoteRequestDTO.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang-M1Pro on 09/08/24.
//

import Foundation
import SwiftData

internal struct UpdateNoteRequestDTO: Encodable {
    let id: String
    let completed: Bool
}
