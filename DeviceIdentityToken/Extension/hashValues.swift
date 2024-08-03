//
//  hashValues.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//

import Foundation
import CryptoSwift

func hashValues(_ values: Any...) throws -> String {
    do {
        var hasher = SHA3(variant: .sha256)
        for value in values {
            if let data = "\(value)".data(using: .utf8) {
                _ = try hasher.update(withBytes: data.bytes)
            }
        }
        let hash = try hasher.finish()
        return Data(hash).toHexString()
    } catch {
        throw error
    }
}
