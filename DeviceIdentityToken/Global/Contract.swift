//
//  Contract.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//

import Foundation
import web3

class Contract {
    public static let shared = Contract()
    
    let DIT_CONTRACT_ADDRESS: String
    let DIT_CONTRACT: EthereumAddress
    let APP_PRIVATE_KEY: String
    
    private init() {
        do {
            self.DIT_CONTRACT_ADDRESS = try getEnvironmentValue(.DITContractAddress)
            self.DIT_CONTRACT = EthereumAddress(self.DIT_CONTRACT_ADDRESS)
            self.APP_PRIVATE_KEY = try getEnvironmentValue(.AppPrivateKey)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
