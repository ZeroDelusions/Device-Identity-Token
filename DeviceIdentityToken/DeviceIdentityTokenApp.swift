//
//  DeviceIdentityTokenApp.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 01/07/2024.
//

import SwiftUI
import AppTrackingTransparency
import metamask_ios_sdk

@main
struct DeviceIdentityTokenApp: App {
    @State private var showTrackingSheet = false
    @State private var startDate = Date()
    
    @StateObject var viewModel = DITViewModel(sqlService: SQLService.shared, ditContract: DITContract.shared)
    
    private func checkTrackingAuthorization() async {
        let status = await MainActor.run {
            ATTrackingManager.trackingAuthorizationStatus
        }
        if status != .authorized {
            await MainActor.run {
                showTrackingSheet = true
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .font(.custom("AnonymousPro-Regular", size: 20))
                .foregroundStyle(Color.customPrimary)
                .background(Color.customBackground)
                .onAppear {
                    Task {
                        await checkTrackingAuthorization()
                    }
                }
                .overlay {
                    viewModel.isPolling
                    ? LoadingScreen().transition(.opacity)
                    : nil
                }
                .fullScreenCover(isPresented: $showTrackingSheet) {
                    TrackingAuthorizationView()
                }
                .environmentObject(viewModel)
        }
    }
}
