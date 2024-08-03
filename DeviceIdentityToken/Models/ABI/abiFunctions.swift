
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public enum AbiFunctions {
    
    public struct mintDIT: ABIFunction {
        public static let name = "mintDIT"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        public let to: EthereumAddress
        public let name: String
        public let description: String
        public let image: String
        public let state: String
        public let wallet_address: String
        public let device_id: String
        public let model_name: String
        public let screen_size: String
        public let os_version: String
        public let last_update: String
        public let event_history: String
//        public let vrf: String
        public let dit_hash: String
        public let messageHash: String
        public let signature: String
        
        
        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil,
            to: EthereumAddress,
            name: String,
            description: String,
            image: String,
            state: String,
            wallet_address: String,
            device_id: String,
            model_name: String,
            screen_size: String,
            os_version: String,
            last_update: String,
            event_history: String,
//            vrf: String,
            dit_hash: String,
            messageHash: String,
            signature: String
            
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.to = to
            self.name = name
            self.description = description
            self.image = image
            self.state = state
            self.wallet_address = wallet_address
            self.device_id = device_id
            self.model_name = model_name
            self.screen_size = screen_size
            self.os_version = os_version
            self.last_update = last_update
            self.event_history = event_history
//            self.vrf = vrf
            self.dit_hash = dit_hash
            self.messageHash = messageHash
            self.signature = signature
            
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(to)
            try encoder.encode(name)
            try encoder.encode(description)
            try encoder.encode(image)
            try encoder.encode(state)
            try encoder.encode(wallet_address)
            try encoder.encode(device_id)
            try encoder.encode(model_name)
            try encoder.encode(screen_size)
            try encoder.encode(os_version)
            try encoder.encode(last_update)
            try encoder.encode(event_history)
//            try encoder.encode(vrf)
            try encoder.encode(dit_hash)
            try encoder.encode(messageHash)
            try encoder.encode(signature)
            
        }
    }
    
    public struct burnDIT: ABIFunction {
        public static let name = "burnDIT"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?

        public let tokenId: BigUInt
        public let messageHash: String
        public let signature: String
        

        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil,
            tokenId: BigUInt,
            messageHash: String,
            signature: String
            
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.tokenId = tokenId
            self.messageHash = messageHash
            self.signature = signature
            
        }

        public func encode(to encoder: ABIFunctionEncoder) throws {
          try encoder.encode(tokenId)
          try encoder.encode(messageHash)
          try encoder.encode(signature)
          
        }
    }

    
//    public struct burnDIT: ABIFunction {
//        public static let name = "burnDIT"
//        public let gasPrice: BigUInt?
//        public let gasLimit: BigUInt?
//        public var contract: EthereumAddress
//        public let from: EthereumAddress?
//        
//        public let device_id: String
//        public let messageHash: String
//        public let signature: String
//        
//        
//        public init(
//            contract: EthereumAddress,
//            from: EthereumAddress? = nil,
//            gasPrice: BigUInt? = nil,
//            gasLimit: BigUInt? = nil,
//            device_id: String,
//            messageHash: String,
//            signature: String
//            
//        ) {
//            self.contract = contract
//            self.from = from
//            self.gasPrice = gasPrice
//            self.gasLimit = gasLimit
//            self.device_id = device_id
//            self.messageHash = messageHash
//            self.signature = signature
//            
//        }
//        
//        public func encode(to encoder: ABIFunctionEncoder) throws {
//            try encoder.encode(device_id)
//            try encoder.encode(messageHash)
//            try encoder.encode(signature)
//            
//        }
//    }
//    public struct remintDIT: ABIFunction {
//        public static let name = "remintDIT"
//        public let gasPrice: BigUInt?
//        public let gasLimit: BigUInt?
//        public var contract: EthereumAddress
//        public let from: EthereumAddress?
//        
//        public let device_id: String
//        public let messageHash: String
//        public let signature: String
//        
//        
//        public init(
//            contract: EthereumAddress,
//            from: EthereumAddress? = nil,
//            gasPrice: BigUInt? = nil,
//            gasLimit: BigUInt? = nil,
//            device_id: String,
//            messageHash: String,
//            signature: String
//            
//        ) {
//            self.contract = contract
//            self.from = from
//            self.gasPrice = gasPrice
//            self.gasLimit = gasLimit
//            self.device_id = device_id
//            self.messageHash = messageHash
//            self.signature = signature
//            
//        }
//        
//        public func encode(to encoder: ABIFunctionEncoder) throws {
//            try encoder.encode(device_id)
//            try encoder.encode(messageHash)
//            try encoder.encode(signature)
//            
//        }
//    }
//    public struct renounceDIT: ABIFunction {
//        public static let name = "renounceDIT"
//        public let gasPrice: BigUInt?
//        public let gasLimit: BigUInt?
//        public var contract: EthereumAddress
//        public let from: EthereumAddress?
//        
//        public let device_id: String
//        public let messageHash: String
//        public let signature: String
//        
//        
//        public init(
//            contract: EthereumAddress,
//            from: EthereumAddress? = nil,
//            gasPrice: BigUInt? = nil,
//            gasLimit: BigUInt? = nil,
//            device_id: String,
//            messageHash: String,
//            signature: String
//            
//        ) {
//            self.contract = contract
//            self.from = from
//            self.gasPrice = gasPrice
//            self.gasLimit = gasLimit
//            self.device_id = device_id
//            self.messageHash = messageHash
//            self.signature = signature
//            
//        }
//        
//        public func encode(to encoder: ABIFunctionEncoder) throws {
//            try encoder.encode(device_id)
//            try encoder.encode(messageHash)
//            try encoder.encode(signature)
//            
//        }
//    }
    public struct updateDIT: ABIFunction {
        public static let name = "updateDIT"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        public let device_id: String
        public let description: String
        public let os_version: String
        public let last_update: String
        public let event_history: String
        public let dit_hash: String
        public let messageHash: String
        public let signature: String
        
        
        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil,
            device_id: String,
            description: String,
            os_version: String,
            last_update: String,
            event_history: String,
            dit_hash: String,
            messageHash: String,
            signature: String
            
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.device_id = device_id
            self.description = description
            self.os_version = os_version
            self.last_update = last_update
            self.event_history = event_history
            self.dit_hash = dit_hash
            self.messageHash = messageHash
            self.signature = signature
            
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(device_id)
            try encoder.encode(description)
            try encoder.encode(os_version)
            try encoder.encode(last_update)
            try encoder.encode(event_history)
            try encoder.encode(dit_hash)
            try encoder.encode(messageHash)
            try encoder.encode(signature)
            
        }
    }
    
    public struct requestRandomWords: ABIFunction {
        public static let name = "requestRandomWords"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil
            
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            
        }
    }
    public struct getRequestStatus: ABIFunction {
        public static let name = "getRequestStatus"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        public let _requestId: BigUInt
        
        
        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil,
            _requestId: BigUInt
            
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self._requestId = _requestId
            
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(_requestId)
            
        }
    }
    public struct lastRequestId: ABIFunction {
        public static let name = "lastRequestId"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        
        
        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil
            
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            
        }
    }
    
    public struct s_vrfCoordinator: ABIFunction {
        public static let name = "s_vrfCoordinator"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        
        
        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil
            
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            
        }
    }
    
    public struct getDITDatabaseName: ABIFunction {
        public static let name = "getDITDatabaseName"
//        public static let name = "getTableName"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        
        public init(
            contract: EthereumAddress,
            from: EthereumAddress? = nil,
            gasPrice: BigUInt? = nil,
            gasLimit: BigUInt? = nil
            
        ) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            
        }
    }
}
