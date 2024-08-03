//
//  DIT+NSCopying.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//

import SwiftUI

extension DIT: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = DIT(
            id: self.id,
            name: self.name,
            description: self.description,
            image: self.image,
            state: self.state,
            wallet_address: self.wallet_address,
            device_id: self.device_id,
            model_name: self.model_name,
            screen_size: self.screen_size,
            os_version: self.os_version,
            last_update: self.last_update,
            dit_hash: self.dit_hash
        )
        return copy
    }
}
