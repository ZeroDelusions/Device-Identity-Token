//
//  Provider.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 01/07/2024.
//

import SwiftUI
import web3
import AdSupport
import metamask_ios_sdk

struct ChainData {
    let id: String
    let idHex: String
    let name: String
    let explorer: String?
    let rpc_urls: [String]
    let currency: NativeCurrency
}

class Provider {
    public static let shared = Provider()
    
    let KEY: String
    let CHAIN_DATA: ChainData
    let CLIENT: EthereumHttpClient

    private init() {
        do {
            self.KEY = try getEnvironmentValue(.ProviderKey)
            
            let chainId = "11155420"
            guard let chainIdHex = chainId.toHex() else {
                throw HexError.wrongInputType
            }
            self.CHAIN_DATA = ChainData(
                id: chainId,
                idHex: chainIdHex,
                name: "OP Sepolia",
                explorer: "https://sepolia-optimistic.etherscan.io",
                rpc_urls: ["https://sepolia.optimism.io"],
                currency: NativeCurrency(
                    name: "Ethereum",
                    symbol: "ETH",
                    decimals: 18
                )
            )
            self.CLIENT = try Provider.initProvider(
                scheme: "https",
                host: "optimism-sepolia.infura.io",
                path: "/v3/", 
                key: KEY,
                chainId: CHAIN_DATA.id
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private static func initProvider(
        scheme: String,
        host: String,
        path: String,
        key: String,
        chainId: String
    ) throws -> EthereumHttpClient {
        var providerUrlComponents = URLComponents()
        providerUrlComponents.scheme = scheme
        providerUrlComponents.host = host
        providerUrlComponents.path = path + key
        
        guard let providerUrl = providerUrlComponents.url else {
            throw ContractError.undefinedEnvironmentVariable
        }
        
        return EthereumHttpClient(url: providerUrl, network: .custom(chainId))
    }
    
}

