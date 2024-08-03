//
//  IdentifiableError.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 08/07/2024.
//

import Foundation

struct IdentifiableError: LocalizedError, Identifiable {
    let id = UUID()
    let underlyingError: LocalizedError
    
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    
    var failureReason: String? {
        underlyingError.failureReason
    }
    
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }
    
    var helpAnchor: String? {
        underlyingError.helpAnchor
    }
}
