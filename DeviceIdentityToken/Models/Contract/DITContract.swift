//
//  DITContract.swift
//  Device Identity Token
//
//  Created by Косоруков Дмитро on 11/05/2024.
//

import SwiftUI
import web3
import BigInt

enum DITState {
    case owned
    case renounced
    case rented
    case escrowed
}

//enum EventHistoryType {
//    case mint
//    case remint
//    case update
//    case renounce
//    case transaction_begin
//    case transaction_end
//    case rent_begin
//    case rent_end
//}
//
//struct EventHistoryElement: Codable {
//    let type: String
//    let from: String
//    let to: String
//    let price: String?
//    let timestamp: String
//    let hash: String
//}

protocol DITData: Equatable {
    var name: String { get set }
    var description: String { get set }
    var image: String { get set }
    var state: String { get set }
    var wallet_address: String { get set }
    var device_id: String { get set }
    var model_name: String { get set }
    var screen_size: String { get set }
    var os_version: String { get }
    var last_update: String { get }
    var dit_hash: String { get }
    
    static func == (lhs: Self, rhs: Self) -> Bool
    static func != (lhs: Self, rhs: Self) -> Bool
}

extension DITData {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name &&
        lhs.description == rhs.description
    }
    
    static func != (lhs: Self, rhs: Self) -> Bool {
        return !(lhs == rhs)
    }
}

protocol DITContractProtocol {
    func mint(_ data: DIT) async throws
    func update(_ data: DIT) async throws
    func burn(_ data: DIT) async throws
}

class DITContract: DITContractProtocol {
    
    static let shared = DITContract()
    let address: String
    let contract: EthereumAddress
    let abiContract: AbiContract
    
    private init() {
        address = Contract.shared.DIT_CONTRACT_ADDRESS
        contract = Contract.shared.DIT_CONTRACT
        abiContract = AbiContract(contract: address, client: ContractCommunicator.shared.client)
    }

    func getDITDatabaseName() async throws -> String {
        return try await abiContract.getDITDatabaseName()
    }

    
    func mint(_ data: DIT) async throws  {
        guard let userAddress = ContractCommunicator.shared.userAddress else {
            throw ContractError.undefinedUserAccount
        }
        
        let userAccount = EthereumAddress(userAddress)
        let (message, signature) = try ContractCommunicator.shared.signAppMessage()
        
        await ContractCommunicator.shared.ensureCorrectChain()
        
        let tx = AbiFunctions.mintDIT(
            contract: contract,
            to: userAccount,
            name: data.name,
            description: data.description,
            image: data.image,
            
            state: "owned",
            wallet_address: ContractCommunicator.shared.userAddress ?? "",
            device_id: data.device_id,
            model_name: data.model_name,
            screen_size: data.screen_size,
            os_version: data.os_version,
            last_update: Date().now(),
            dit_hash: try hashValues(data.reflected(.values)),
            message: message,
            signature: signature
        )
        
        let encoder = ABIFunctionEncoder(AbiFunctions.mintDIT.name)
        try tx.encode(to: encoder)
        let encodedData = try encoder.encoded()
        let _ = try await ContractCommunicator.shared.sendTransaction(to: address, data: encodedData.toHexString())
        
    }
    
    func update(_ data: DIT) async throws  {
        guard let _ = ContractCommunicator.shared.userAddress else {
            throw ContractError.undefinedUserAccount
        }
        
        let (message, signature) = try ContractCommunicator.shared.signAppMessage()
        
        await ContractCommunicator.shared.ensureCorrectChain()

        let tx = AbiFunctions.updateDIT(
            contract: contract,
            tokenId: BigUInt(stringLiteral: data.id),
            description: data.description,
            os_version: data.os_version,
            last_update: Date().now(),
            dit_hash: try hashValues(data.reflected(.values)),
            message: message,
            signature: signature
        )
        
        let encoder = ABIFunctionEncoder(AbiFunctions.updateDIT.name)
        try tx.encode(to: encoder)
        let encodedData = try encoder.encoded()
        let _ = try await ContractCommunicator.shared.sendTransaction(to: address, data: encodedData.toHexString())
    }
    
    func burn(_ data: DIT) async throws  {
        guard let _ = ContractCommunicator.shared.userAddress else {
            throw ContractError.undefinedUserAccount
        }
        
        let (message, signature) = try ContractCommunicator.shared.signAppMessage()
        
        await ContractCommunicator.shared.ensureCorrectChain()
        
        let tx = AbiFunctions.burnDIT(
            contract: contract,
            tokenId: BigUInt(stringLiteral: data.id),
            message: message,
            signature: signature
        )
        
        let encoder = ABIFunctionEncoder(AbiFunctions.burnDIT.name)
        try tx.encode(to: encoder)
        let encodedData = try encoder.encoded()
        let _ = try await ContractCommunicator.shared.sendTransaction(to: address, data: encodedData.toHexString())
        
    }
}



