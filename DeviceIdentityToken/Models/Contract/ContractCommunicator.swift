//
//  ContractCommunicator.swift
//  Device Identity Token
//
//  Created by Косоруков Дмитро on 02/05/2024.
//

import SwiftUI
import web3
import BigInt
import CryptoSwift
import metamask_ios_sdk
import web3

class ContractCommunicator: ObservableObject {
    
    static let shared = ContractCommunicator()
    private static let APP_METADATA = AppMetadata(name: "Device Identity Token", url: "https://dubdapp.com")
    
    var message: String? {
        do {
            let uuid = UUID().uuidString
            let rand = String(Float.random(in: 0...9999))
            let combined = uuid + rand + (userAddress ?? "")
            let hashed = try hashValues(combined)
            return hashed
        } catch {
            return nil
        }
    }
    
    let appKeyStorage = EthereumKeyLocalStorage()
    var appAccount: EthereumAccount?
    let client: EthereumHttpClient
    
    @Published var metamaskSDK = MetaMaskSDK.shared(APP_METADATA, sdkOptions: SDKOptions(infuraAPIKey: Provider.shared.KEY))
    @Published var userAddress: String? = nil
    
    private init() {
        client = Provider.shared.CLIENT
        do {
            appAccount = try EthereumAccount.importAccount(replacing: appKeyStorage, privateKey: Contract.shared.APP_PRIVATE_KEY, keystorePassword: "reallydamngoodpasswordfordit")
        } catch {
            print("Failed to import account: \(error)")
        }
    }
    
    func connectMetaMask() async throws {
        let result = await metamaskSDK.connect()
        switch result {
        case .success(_):
            userAddress = metamaskSDK.account
        case .failure(let err):
            throw err
        }
    }
    
    func ensureCorrectChain() async {
        await addOpSepoliaChain()
        await switchToProviderChain()
    }
    
    private func switchToProviderChain() async {
        print(Provider.shared.CHAIN_DATA.idHex)
        let _ = await metamaskSDK.switchEthereumChain(chainId: Provider.shared.CHAIN_DATA.idHex)
    }
    
    private func addOpSepoliaChain() async {
        let chainData = Provider.shared.CHAIN_DATA
        let _ = await metamaskSDK.addEthereumChain(
            chainId: Provider.shared.CHAIN_DATA.idHex,
            chainName: chainData.name,
            rpcUrls: chainData.rpc_urls,
            iconUrls: nil,
            blockExplorerUrls: nil,
            nativeCurrency: chainData.currency
        )
    }
    
    func signAppMessage() throws -> (message: String, signature: String) {
        do {
            guard let appAccount else {
                throw ContractError.undefinedEnvironmentVariable
            }
            
            guard let _ = userAddress else {
                throw ContractError.undefinedUserAccount
            }
            
            guard let message else {
                throw ContractError.signatureMessageEncryptionError
            }
            
            let prefix = "\u{19}Ethereum Signed Message:\n\(String(message.count))"
            guard var data = prefix.data(using: .ascii) else {
                throw EthereumAccountError.signError
            }
            
            guard let messageData = message.data(using: .utf8) else {
                throw ContractError.undefinedEnvironmentVariable
            }
            
            let signedMessage = try appAccount.signMessage(message: messageData).web3.noHexPrefix
            
            data.append(messageData)
            let messageHex = data.web3.keccak256.toHexString()
            
            /// Test key recovery in app console:
            //             print("Signature: \(signedMessage)", "Message hash: \(message)")
            //             print(
//                             "Expected address: \(appAccount.address.asString())",
            //                 "Recovered address: \(try KeyUtil.recoverPublicKey(message: data.web3.keccak256, signature: signedMessage.web3.hexData!))"
            //             )
            
            return (messageHex, signedMessage)
        } catch {
            throw error
        }
    }
    
    func sendTransaction(to: String, data: String, value: String = "0x0") async throws -> String {
        
        var txHash: String = ""
        if let userAddress {
            let transaction = MetaMaskTransaction(
                to: to, from: userAddress, value: value, data: data
            )
            
            let transactionRequest = EthereumRequest(
                method: .ethSendTransaction,
                params: [transaction]
            )
            
            let result = await metamaskSDK.request(transactionRequest)
            switch result {
            case .success(let tx):
                txHash = tx
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        return txHash
    }
}
