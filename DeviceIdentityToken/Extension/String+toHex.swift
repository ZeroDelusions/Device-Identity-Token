//
//  String+toHex.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//

import Foundation

enum HexError: Error {
    case wrongInputType
}

extension HexError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongInputType:
            return "Cannot convert input type String to type Int. Ensure only numbers are included."
        }
    }
}

extension String {
    func toHex() -> String? {
        guard let intValue = Int(self) else { return nil }
        return intValue.toHex()
    }
}

extension Int {
    func toHex() -> String {
        return String(format: "0x%x", self)
    }
}
