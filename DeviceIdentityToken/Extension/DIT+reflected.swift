//
//  DIT+reflected.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 03/07/2024.
//

import Foundation
import Combine

extension DIT {
    enum ReflectionOption {
        case keysAndValues
        case keys
        case values
    }
    
    func reflected(_ option: ReflectionOption = .keysAndValues) -> [ReflectedProperty] {
        let mirror = Mirror(reflecting: self)
        
        switch option {
        case .keysAndValues:
            return reflectedKeysAndValues(mirror: mirror)
        case .keys:
            return reflectedKeys(mirror: mirror).map { ReflectedProperty(key: $0, value: "") }
        case .values:
            return reflectedValues(mirror: mirror).map { ReflectedProperty(key: "", value: $0) }
        }
    }
    
    private func reflectedKeysAndValues(mirror: Mirror) -> [ReflectedProperty] {
        mirror.children.compactMap { child in
            guard let label = child.label,
                  let publishedValue = child.value as? Published<String>,
                  let value = Mirror(reflecting: publishedValue).descendant("storage", "value") as? String else {
                return nil
            }
            let formattedKey = formatKey(key: label.hasPrefix("_") ? String(label.dropFirst()) : label)
            return ReflectedProperty(key: formattedKey, value: value)
        }
    }
    
    private func reflectedKeys(mirror: Mirror) -> [String] {
        mirror.children.compactMap { child in
            guard let label = child.label, child.value is Published<String> else { return nil }
            return formatKey(key: label.hasPrefix("_") ? String(label.dropFirst()) : label)
        }
    }
    
    private func reflectedValues(mirror: Mirror) -> [String] {
        mirror.children.compactMap { child in
            guard let publishedValue = child.value as? Published<String>,
                  let value = Mirror(reflecting: publishedValue).descendant("storage", "value") as? String else {
                return nil
            }
            return value
        }
    }
    
    internal func formatKey(key: String) -> String {
        key.split(separator: "_")
           .map { $0.prefix(1).uppercased() + $0.dropFirst() }
           .joined(separator: " ")
    }
}

struct ReflectedProperty: Identifiable {
    let id = UUID()
    let key: String
    let value: String
}

