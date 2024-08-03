//
//  ContractErrors.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 01/07/2024.
//

import Foundation

enum ContractError: Error {
    case undefinedEnvironmentVariable
    case undefinedUserAccount
    case signatureMessageEncryptionError
}

extension ContractError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .undefinedEnvironmentVariable:
            return "Error accessing environmental variable. Please compare passed key to environmental variable key in 'Product > Scheme > Edit Scheme > Run > Arguments > Environment Variables', or create new one."
        
        case .undefinedUserAccount:
            return "Make sure user account is created properly."
            
        case .signatureMessageEncryptionError:
            return "Error encrypting signature message."
        }
    }
}
