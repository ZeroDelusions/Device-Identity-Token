import BigInt
import Foundation
import web3

public protocol AbiProtocol {
    init(client: EthereumClientProtocol)
    
    func mintDIT(contractAddress: EthereumAddress , to: EthereumAddress, name: String, description: String, image: String, state: String, wallet_address: String, device_id: String, model_name: String, screen_size: String, os_version: String, last_update: String, dit_hash: String, message: String, signature: String ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
    func updateDIT(contractAddress: EthereumAddress , tokenId: BigUInt, description: String, os_version: String, last_update: String, dit_hash: String, message: String, signature: String ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
    func burnDIT(contractAddress: EthereumAddress , tokenId: BigUInt, message: String, signature: String ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
    func balanceOf(contractAddress: EthereumAddress , owner: EthereumAddress ) async throws -> BigUInt
    func getAppPublicKey(contractAddress: EthereumAddress  ) async throws -> EthereumAddress
    func getApproved(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> EthereumAddress
    func getDITDatabase(contractAddress: EthereumAddress  ) async throws -> EthereumAddress
    func getDITDatabaseName(contractAddress: EthereumAddress  ) async throws -> String
    func name(contractAddress: EthereumAddress  ) async throws -> String
    func owner(contractAddress: EthereumAddress  ) async throws -> EthereumAddress
    func ownerOf(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> EthereumAddress
    func symbol(contractAddress: EthereumAddress  ) async throws -> String
    func tokenURI(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> String
    func totalSupply(contractAddress: EthereumAddress  ) async throws -> BigUInt
    
       
    //    func remintDIT(contractAddress: EthereumAddress , device_id: String, message: String, signature: String ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
    //    func renounceDIT(contractAddress: EthereumAddress , device_id: String, message: String, signature: String ,from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction
    
}

open class Abi: AbiProtocol {
    
    let client: EthereumClientProtocol
    
    required public init(client: EthereumClientProtocol) {
        self.client = client
    }
    
    public func mintDIT(contractAddress: EthereumAddress , to: EthereumAddress, name: String, description: String, image: String, state: String, wallet_address: String, device_id: String, model_name: String, screen_size: String, os_version: String, last_update: String, dit_hash: String, message: String, signature: String, from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction {
        let tryCall = AbiFunctions.mintDIT(contract: contractAddress, from: from, gasPrice: gasPrice, to: to, name: name, description: description, image: image, state: state, wallet_address: wallet_address, device_id: device_id, model_name: model_name, screen_size: screen_size, os_version: os_version, last_update: last_update, dit_hash: dit_hash, message: message, signature: signature)
        let subdata = try tryCall.transaction()
        let gas = try await client.eth_estimateGas(subdata)
        let function = AbiFunctions.mintDIT(contract: contractAddress, from: from, gasPrice: gasPrice,gasLimit: gas, to: to, name: name, description: description, image: image, state: state, wallet_address: wallet_address, device_id: device_id, model_name: model_name, screen_size: screen_size, os_version: os_version, last_update: last_update, dit_hash: dit_hash, message: message, signature: signature)
        let data = try function.transaction()
        return data
    }
    public func updateDIT(contractAddress: EthereumAddress , tokenId: BigUInt, description: String, os_version: String, last_update: String, dit_hash: String, message: String, signature: String, from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction {
        let tryCall = AbiFunctions.updateDIT(contract: contractAddress, from: from, gasPrice: gasPrice, tokenId: tokenId, description: description, os_version: os_version, last_update: last_update, dit_hash: dit_hash, message: message, signature: signature)
        let subdata = try tryCall.transaction()
        let gas = try await client.eth_estimateGas(subdata)
        let function = AbiFunctions.updateDIT(contract: contractAddress, from: from, gasPrice: gasPrice,gasLimit: gas, tokenId: tokenId, description: description, os_version: os_version, last_update: last_update, dit_hash: dit_hash, message: message, signature: signature)
        let data = try function.transaction()
        return data
    }
    public func burnDIT(contractAddress: EthereumAddress , tokenId: BigUInt, message: String, signature: String, from: EthereumAddress, gasPrice: BigUInt) async throws -> EthereumTransaction {
        let tryCall = AbiFunctions.burnDIT(contract: contractAddress, from: from, gasPrice: gasPrice, tokenId: tokenId, message: message, signature: signature)
        let subdata = try tryCall.transaction()
        let gas = try await client.eth_estimateGas(subdata)
        let function = AbiFunctions.burnDIT(contract: contractAddress, from: from, gasPrice: gasPrice,gasLimit: gas, tokenId: tokenId, message: message, signature: signature)
        let data = try function.transaction()
        return data
    }
    
    public func balanceOf(contractAddress: EthereumAddress , owner: EthereumAddress) async throws -> BigUInt {
        let function = AbiFunctions.balanceOf(contract: contractAddress , owner: owner)
        let data = try await function.call(withClient: client, responseType: AbiResponses.balanceOfResponse.self)
        return data.value
    }
    public func getAppPublicKey(contractAddress: EthereumAddress ) async throws -> EthereumAddress {
        let function = AbiFunctions.getAppPublicKey(contract: contractAddress )
        let data = try await function.call(withClient: client, responseType: AbiResponses.getAppPublicKeyResponse.self)
        return data.value
    }
    public func getApproved(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> EthereumAddress {
        let function = AbiFunctions.getApproved(contract: contractAddress , tokenId: tokenId)
        let data = try await function.call(withClient: client, responseType: AbiResponses.getApprovedResponse.self)
        return data.value
    }
    public func getDITDatabase(contractAddress: EthereumAddress ) async throws -> EthereumAddress {
        let function = AbiFunctions.getDITDatabase(contract: contractAddress )
        let data = try await function.call(withClient: client, responseType: AbiResponses.getDITDatabaseResponse.self)
        return data.value
    }
    public func getDITDatabaseName(contractAddress: EthereumAddress ) async throws -> String {
        let function = AbiFunctions.getDITDatabaseName(contract: contractAddress )
        let data = try await function.call(withClient: client, responseType: AbiResponses.getDITDatabaseNameResponse.self)
        return data.value
    }
    public func name(contractAddress: EthereumAddress ) async throws -> String {
        let function = AbiFunctions.name(contract: contractAddress )
        let data = try await function.call(withClient: client, responseType: AbiResponses.nameResponse.self)
        return data.value
    }
    public func owner(contractAddress: EthereumAddress ) async throws -> EthereumAddress {
        let function = AbiFunctions.owner(contract: contractAddress )
        let data = try await function.call(withClient: client, responseType: AbiResponses.ownerResponse.self)
        return data.value
    }
    public func ownerOf(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> EthereumAddress {
        let function = AbiFunctions.ownerOf(contract: contractAddress , tokenId: tokenId)
        let data = try await function.call(withClient: client, responseType: AbiResponses.ownerOfResponse.self)
        return data.value
    }
    public func symbol(contractAddress: EthereumAddress ) async throws -> String {
        let function = AbiFunctions.symbol(contract: contractAddress )
        let data = try await function.call(withClient: client, responseType: AbiResponses.symbolResponse.self)
        return data.value
    }
    public func tokenURI(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> String {
        let function = AbiFunctions.tokenURI(contract: contractAddress , tokenId: tokenId)
        let data = try await function.call(withClient: client, responseType: AbiResponses.tokenURIResponse.self)
        return data.value
    }
    public func totalSupply(contractAddress: EthereumAddress ) async throws -> BigUInt {
        let function = AbiFunctions.totalSupply(contract: contractAddress )
        let data = try await function.call(withClient: client, responseType: AbiResponses.totalSupplyResponse.self)
        return data.value
    }
    
}
open class AbiContract {
    var abiCall: Abi?
    var client: EthereumClientProtocol
    var contract: web3.EthereumAddress
    
    init(contract: String, client: EthereumClientProtocol) {
        self.contract = EthereumAddress(contract)
        self.client = client
        self.abiCall = Abi(client: client)
    }
    
    public func mintDIT(to: EthereumAddress,name: String,description: String,image: String,state: String,wallet_address: String,device_id: String,model_name: String,screen_size: String,os_version: String,last_update: String,dit_hash: String,message: String,signature: String, account: EthereumAccount) async throws -> String{
        let gasPrice = try await client.eth_gasPrice()
        let transaction = try await (abiCall?.mintDIT(contractAddress:contract,to: to,name: name,description: description,image: image,state: state,wallet_address: wallet_address,device_id: device_id,model_name: model_name,screen_size: screen_size,os_version: os_version,last_update: last_update,dit_hash: dit_hash,message: message,signature: signature, from: account.address, gasPrice: gasPrice))!
        let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
        return txHash
    }
    
    
    public func updateDIT(tokenId: BigUInt, description: String,os_version: String,last_update: String,dit_hash: String,message: String,signature: String, account: EthereumAccount) async throws -> String{
        let gasPrice = try await client.eth_gasPrice()
        let transaction = try await (abiCall?.updateDIT(contractAddress:contract,tokenId: tokenId,description: description,os_version: os_version,last_update: last_update,dit_hash: dit_hash,message: message,signature: signature, from: account.address, gasPrice: gasPrice))!
        let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
        return txHash
    }
    
    public func burnDIT(tokenId: BigUInt,message: String,signature: String, account: EthereumAccount) async throws -> String{
        let gasPrice = try await client.eth_gasPrice()
        let transaction = try await (abiCall?.burnDIT(contractAddress:contract,tokenId: tokenId,message: message,signature: signature, from: account.address, gasPrice: gasPrice))!
        let txHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
        return txHash
    }
    
    public func balanceOf(owner: EthereumAddress) async throws -> BigUInt{
        return try await (abiCall?.balanceOf(contractAddress: contract, owner: owner))!
    }
    
    public func getAppPublicKey() async throws -> EthereumAddress{
        return try await (abiCall?.getAppPublicKey(contractAddress: contract))!
    }
    
    public func getApproved(tokenId: BigUInt) async throws -> EthereumAddress{
        return try await (abiCall?.getApproved(contractAddress: contract, tokenId: tokenId))!
    }
    
    public func getDITDatabase() async throws -> EthereumAddress{
        return try await (abiCall?.getDITDatabase(contractAddress: contract))!
    }
    
    public func getDITDatabaseName() async throws -> String{
        return try await (abiCall?.getDITDatabaseName(contractAddress: contract))!
    }
    
    public func name() async throws -> String{
        return try await (abiCall?.name(contractAddress: contract))!
    }
    
    public func owner() async throws -> EthereumAddress{
        return try await (abiCall?.owner(contractAddress: contract))!
    }
    
    public func ownerOf(tokenId: BigUInt) async throws -> EthereumAddress{
        return try await (abiCall?.ownerOf(contractAddress: contract, tokenId: tokenId))!
    }
    
    public func symbol() async throws -> String{
        return try await (abiCall?.symbol(contractAddress: contract))!
    }
    
    public func tokenURI(tokenId: BigUInt) async throws -> String{
        return try await (abiCall?.tokenURI(contractAddress: contract, tokenId: tokenId))!
    }
    
    public func totalSupply() async throws -> BigUInt{
        return try await (abiCall?.totalSupply(contractAddress: contract))!
    }
    
}
extension Abi {
    public func balanceOf(contractAddress: EthereumAddress, owner: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
        Task {
            do {
                let balanceOf = try await balanceOf(contractAddress: contractAddress , owner: owner)
                completionHandler(.success(balanceOf))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func getAppPublicKey(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
        Task {
            do {
                let getAppPublicKey = try await getAppPublicKey(contractAddress: contractAddress )
                completionHandler(.success(getAppPublicKey))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func getApproved(contractAddress: EthereumAddress, tokenId: BigUInt,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
        Task {
            do {
                let getApproved = try await getApproved(contractAddress: contractAddress , tokenId: tokenId)
                completionHandler(.success(getApproved))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func getDITDatabase(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
        Task {
            do {
                let getDITDatabase = try await getDITDatabase(contractAddress: contractAddress )
                completionHandler(.success(getDITDatabase))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func getDITDatabaseName(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let getDITDatabaseName = try await getDITDatabaseName(contractAddress: contractAddress )
                completionHandler(.success(getDITDatabaseName))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func name(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let name = try await name(contractAddress: contractAddress )
                completionHandler(.success(name))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func owner(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
        Task {
            do {
                let owner = try await owner(contractAddress: contractAddress )
                completionHandler(.success(owner))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func ownerOf(contractAddress: EthereumAddress, tokenId: BigUInt,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
        Task {
            do {
                let ownerOf = try await ownerOf(contractAddress: contractAddress , tokenId: tokenId)
                completionHandler(.success(ownerOf))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func symbol(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let symbol = try await symbol(contractAddress: contractAddress )
                completionHandler(.success(symbol))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func tokenURI(contractAddress: EthereumAddress, tokenId: BigUInt,  completionHandler: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let tokenURI = try await tokenURI(contractAddress: contractAddress , tokenId: tokenId)
                completionHandler(.success(tokenURI))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    public func totalSupply(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
        Task {
            do {
                let totalSupply = try await totalSupply(contractAddress: contractAddress )
                completionHandler(.success(totalSupply))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}
