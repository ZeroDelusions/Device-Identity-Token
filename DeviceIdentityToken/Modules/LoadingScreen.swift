//
//  LoadingScreen.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//
import SwiftUI


struct LoadingScreen: View {

    var body: some View{
        GeometryReader { geo in
            ZStack {
                Color.clear
                    .background(.ultraThinMaterial)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                ProgressView()
                    .font(.title)
                    .frame(maxWidth: geo.size.width * 0.5, maxHeight: geo.size.width * 0.5)
            }
            .ignoresSafeArea()
        }
        
        
    }
}

