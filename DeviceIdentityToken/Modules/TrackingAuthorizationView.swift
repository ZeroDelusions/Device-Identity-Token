//
//  TrackingAuthorizationView.swift
//  Device Identity Token
//
//  Created by Косоруков Дмитро on 11/05/2024.
//

import SwiftUI
import AppTrackingTransparency
import AdSupport

struct TrackingAuthorizationView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Tracking Required")
                    .font(.largeTitle)
                    .padding()

                Text("Allowing tracking is essential for generating unique device id. Please enable tracking in settings.")
                    .multilineTextAlignment(.center)
                    .padding()

                Button("Open Settings") {
                    openSettings()
                }
                .padding()
            }
        }
    }

    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { success in
                print("Settings opened: \(success)")
            })
        }
    }
}
