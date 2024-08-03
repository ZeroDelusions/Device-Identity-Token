//
//  MetaMaskTransaction.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//

import SwiftUI
import metamask_ios_sdk

struct MetaMaskTransaction: CodableData {
    let to: String
    let from: String
    let value: String
    let data: String?
    
    init(to: String, from: String, value: String, data: String? = nil) {
        self.to = to
        self.from = from
        self.value = value
        self.data = data
    }
    
    func socketRepresentation() -> NetworkData {
        [
            "to": to,
            "from": from,
            "value": value,
            "data": data
        ]
    }
}
