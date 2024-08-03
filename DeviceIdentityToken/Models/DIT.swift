//
//  DIT.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 03/07/2024.
//

import SwiftUI

class DIT: ObservableObject, DITData {
    
    static let empty = DIT()
    
    @Published var id: String
    @Published var name: String
    @Published var description: String
    @Published var image: String
    @Published var state: String
    @Published var wallet_address: String
    @Published var device_id: String
    @Published var model_name: String
    @Published var screen_size: String
    @Published var os_version: String
    @Published var last_update: String
    @Published var dit_hash: String
    
    init() {
        self.id = ""
        self.name = ""
        self.description = ""
        self.image = ""
        self.state = ""
        self.wallet_address = ""
        self.device_id = Device.shared.AD_ID
        self.model_name = Device.shared.CURRENT.modelName
        self.screen_size = Device.shared.SCREEN_SIZE
        self.os_version = Device.shared.CURRENT.systemVersion
        self.last_update = ""
        self.dit_hash = ""
    }
    
    internal init(id: String, name: String, description: String, image: String, state: String, wallet_address: String, device_id: String, model_name: String, screen_size: String, os_version: String, last_update: String, dit_hash: String) {
        self.id = id
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
        self.dit_hash = dit_hash
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        wallet_address = try container.decodeIfPresent(String.self, forKey: .wallet_address) ?? ""
        device_id = try container.decodeIfPresent(String.self, forKey: .device_id) ?? ""
        model_name = try container.decodeIfPresent(String.self, forKey: .model_name) ?? ""
        screen_size = try container.decodeIfPresent(String.self, forKey: .screen_size) ?? ""
        os_version = try container.decodeIfPresent(String.self, forKey: .os_version) ?? ""
        last_update = try container.decodeIfPresent(String.self, forKey: .last_update) ?? ""
        dit_hash = try container.decodeIfPresent(String.self, forKey: .dit_hash) ?? ""
    }
}
