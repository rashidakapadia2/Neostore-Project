//
//  CustomErrors.swift
//  Neostore
//
//  Created by Neosoft on 22/02/22.
//  Copyright © 2022 Neosoft. All rights reserved.
//

import Foundation

enum CustomErrors: Error {
    case noInternet
    case noData
}

extension CustomErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "Could not connect to the internet."
        case .noData:
            return "No data Available"
        }
    }
}
