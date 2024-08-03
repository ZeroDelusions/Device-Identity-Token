//
//  DIT+Codable.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 03/07/2024.
//

import Foundation

extension DIT: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, description, image, state, wallet_address, device_id, model_name, screen_size, os_version, last_update, dit_hash
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(image, forKey: .image)
        try container.encode(state, forKey: .state)
        try container.encode(wallet_address, forKey: .wallet_address)
        try container.encode(device_id, forKey: .device_id)
        try container.encode(model_name, forKey: .model_name)
        try container.encode(screen_size, forKey: .screen_size)
        try container.encode(os_version, forKey: .os_version)
        try container.encode(last_update, forKey: .last_update)
        try container.encode(dit_hash, forKey: .dit_hash)
    }
    
    func update(_ data: DIT) {
        DispatchQueue.main.async {
            self.id = data.id
            self.name = data.name
            self.description = data.description
            self.image = data.image
            self.state = data.state
            self.wallet_address = data.wallet_address
            self.device_id = data.device_id
            self.model_name = data.model_name
            self.screen_size = data.screen_size
            self.os_version = data.os_version
            self.last_update = data.last_update
            self.dit_hash = data.dit_hash
        }
    }
}
