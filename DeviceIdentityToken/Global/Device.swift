//
//  Device.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//

import SwiftUI
import AdSupport

class Device {
    public static let shared = Device()
    
    let CURRENT: UIDevice
    let AD_ID: String
    let SCREEN: CGSize
    let SCREEN_SIZE: String
    
    private init() {
        self.CURRENT = UIDevice.current
        self.AD_ID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        self.SCREEN = UIScreen.main.nativeBounds.size
        self.SCREEN_SIZE = "\(SCREEN.width)x\(SCREEN.height)"
    }
}
