//
//  Date+now.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 03/07/2024.
//

import Foundation

extension Date {
    func now() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm a"
        
        let currentDate = formatter.string(from: self)
        return currentDate
    }
}
