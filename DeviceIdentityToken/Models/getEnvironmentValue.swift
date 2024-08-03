//
//  getEnvironmentValue.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 01/07/2024.
//

import SwiftUI

enum EnvKeys: String {
    case AppPrivateKey = "APP_PRIVATE_KEY"
    case DITContractAddress = "DIT_CONTRACT_ADDRESS"
    case ProviderKey = "PROVIDER_KEY"
}

func getEnvironmentValue(_ key: EnvKeys) throws -> String {
    guard let envValue = ProcessInfo.processInfo.environment[key.rawValue] else {
        throw ContractError.undefinedEnvironmentVariable
    }
    return envValue
}


