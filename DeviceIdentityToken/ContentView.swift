//
//  ContentView.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 01/07/2024.
//

import SwiftUI
import metamask_ios_sdk
import CoreHaptics

// Not too elegant and optimised. But to be honest. I'm a little burned down by this project.
// Maybe will reconstruct later.

struct ContentView: View {
    @EnvironmentObject var viewModel: DITViewModel
    @Namespace private var animation
    
    @State private var scrollOffset: CGPoint = .zero
    @State private var isScrolling = false
    @State private var hapticTriggered = false
    @State private var triggerTransition = false
    
    private let scrollTransitionThreshold: CGFloat = 40
    private let scrollOffsetBalancer: CGFloat = 0
    
    var body: some View {
        ZStack {
            
            mainScreen
            VStack {
                Text("iPhone Xr")
                    .padding(10)
                    .background(
                        Capsule()
                            .fill(.thinMaterial)
                    )
                    .offset(y: -scrollOffset.y * 0.5)
                    .opacity(!pastThreshold && !triggerTransition ? 1 : 0)
                    .animation(.spring, value: triggerTransition)
                    .animation(.spring, value: pastThreshold)
                
                Spacer()
                
            }
            scrollView
            contentOverlay
        }
        .onAppear(perform: setupView)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Phone information view")
    }
}

// MARK: - View Components
private extension ContentView {
    
    var mainScreen: some View {
        backgroundImage
    }
    
    @ViewBuilder
    var backgroundGradient: some View {
        LinearGradient(
            colors: [.black, Color.black.opacity(triggerTransition ? 0 : 1)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    @ViewBuilder
    var ChevronView: some View {
        
        Button(action: { triggerTransition.toggle() }) {
            ZStack {
                Circle()
                    .trim(from: 0, to: balancedScroll / scrollTransitionThreshold)
                    .fill(pastThreshold ? Color.customPrimary : Color.clear)
                    .stroke(Color.customPrimary, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(pastThreshold ? Color.customBackground : Color.customPrimary)
                    .offset(y: max(0, balancedScroll / 30))
            }
        }
        .frame(width: 30, height: 30)
        .offset(y: max(0, balancedScroll / 10))
        .scaleEffect(pastThreshold ? 1.4 : max(1, min(1.2, pow(1.2, balancedScroll / scrollTransitionThreshold))))
        .animation(.bouncy, value: pastThreshold)
        
    }
    
    @ViewBuilder
    var contentOverlay: some View {
        ZStack {
            DataView(triggerTransition: $triggerTransition)
                .offset(y: triggerTransition ? 0 : 20)
                .blur(radius: triggerTransition ? 0 : 10)
                .allowsHitTesting(triggerTransition)
            
            VStack {
                Spacer()
                ChevronView
            }
            .padding(.bottom, 60)
            .opacity(triggerTransition ? 0 : 1)
            .offset(y: triggerTransition ? -20 : 0)
        }
        .offset(y: triggerTransition && scrollOffset.y < 0 ? -scrollOffset.y * 0.5 : 0)
        .animation(.spring, value: triggerTransition)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    @ViewBuilder
    var backgroundImage: some View {
        Image("phone_struct")
            .resizable()
            .scaledToFit()
            .mask(backgroundGradient)
            .offset(y: -scrollOffset.y)
            .blur(radius: triggerTransition ? 1 : 0)
            .animation(backgroundAnimation, value: triggerTransition)
            .opacity(triggerTransition ? 0.35 : 0.7)
            .animation(.easeOut(duration: 0.2), value: triggerTransition)
            .padding(.horizontal, 40)
            .padding(.bottom, triggerTransition ? 300 : 20)
    }
    
    @ViewBuilder
    var scrollView: some View {
        ScrollViewObserved(offset: $scrollOffset, isScrolling: $isScrolling) {
            Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: isScrolling, handleScrollStateChange)
        .sensoryFeedback(trigger: scrollOffset.y, provideFeedback)
    }
    
}


// MARK: - Computed Properties
private extension ContentView {
    var balancedScroll: CGFloat {
        scrollOffset.y - scrollOffsetBalancer
    }
    
    var pastThreshold: Bool {
        balancedScroll >= scrollTransitionThreshold
    }
    
    var backgroundAnimation: Animation {
        .interpolatingSpring(mass: 2, stiffness: 200, damping: 20, initialVelocity: 1)
    }
}

// MARK: - Methods
private extension ContentView {
    func setupView() {
        triggerTransition = false
    }
    
    func handleScrollStateChange() {
        print(isScrolling)
        if !isScrolling {
            triggerTransition = pastThreshold
        }
    }
    
    func provideFeedback(oldValue: CGFloat, newValue: CGFloat) -> SensoryFeedback? {
        if !hapticTriggered && pastThreshold {
            hapticTriggered = true
            return .impact(flexibility: .solid, intensity: 4)
        } else if hapticTriggered && !pastThreshold && !triggerTransition {
            hapticTriggered = false
            return .impact(flexibility: .soft, intensity: 2)
        }
        return .none
    }
}

struct DataView: View {
    @EnvironmentObject var viewModel: DITViewModel
    @State var percantage: CGPoint = .zero
    
    @Binding var triggerTransition: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                ZStack {
                    VStack {
                        headerView
                        
                        Image(systemName: "chevron.down")
                            .frame(width: 30)
                            .padding(.vertical, 5)
                            .rotationEffect(.degrees(180))
                            .offset(y: -percantage.y * 20)
                            .opacity(percantage.y >= 0.8 ? 1 : 0)
                        
                        scrollView
                        
                        Image(systemName: "chevron.down")
                            .frame(width: 30)
                            .padding(.vertical, 5)
                            .offset(y: -percantage.y * 20)
                            .opacity(percantage.y >= 0.8 ? 0 : 1)
                        
                        
                        if ContractCommunicator.shared.userAddress == nil  {
                            StyledButton("connect metamask") {
                                Task {
                                    try await ContractCommunicator.shared.connectMetaMask()
                                }
                            }
                            .frame(maxWidth: geo.size.width / 2)
                            .padding(.top, 20)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                            
                        } else if viewModel.fetchedDit.id == "" {
                            StyledButton("mint") {
                                Task {
                                    await viewModel.mint()
                                }
                            }
                            .frame(maxWidth: geo.size.width / 2)
                            .padding(.top, 20)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        } else if viewModel.isChanged {
                            StyledButton("update") {
                                Task {
                                    await viewModel.update()
                                }
                            }
                            .frame(maxWidth: geo.size.width / 2)
                            .padding(.top, 20)
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        }
                        
                        
                        
                        Text("updated - \(viewModel.fetchedDit.last_update)")
                            .textCase(.uppercase)
                            .opacity(0.4)
                            .padding(.vertical, 20)
                    }
                }
                .frame(maxHeight: geo.size.height * 0.55)
            }
            .padding(.horizontal, 40)
            .animation(.easeInOut(duration: 0.2), value: percantage)
        }
    }
}

private extension DataView {
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Text("info")
                .textCase(.uppercase)
                .mask(
                    GeometryReader { geo1 in
                        Color.black
                            .offset(x: triggerTransition ? 0 : -geo1.size.width)
                            .animation(triggerTransition ? .easeOut.delay(0.4) : .none, value: triggerTransition)
                    }
                )
                .padding(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(headerBackground)
                .foregroundStyle(Color.customBackground)
                .fontWeight(.bold)
            
            Text("//")
                .opacity(0)
            StyledButton("burn") {
                Task {
                    await viewModel.burn()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.red)
            .allowsTightening(true)
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
        }
    }
    
    @ViewBuilder
    private var headerBackground: some View {
        ZStack {
            Rectangle()
                .fill(Color.customPrimary)
                .mask(
                    Color.black
                        .frame(maxWidth: triggerTransition ? .infinity : 0, alignment: .leading)
                )
            
            Rectangle()
                .trim(from: 0, to: triggerTransition ? 1 : 0)
                .stroke(Color.customPrimary, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .opacity(triggerTransition ? 1 : 0)
                .rotationEffect(.degrees(0))
        }
        .offset(x: triggerTransition ? 0 : -50)
        .animation(.spring.delay(0), value: triggerTransition)
    }
    
    @ViewBuilder
    private var scrollView: some View {
        ScrollViewObserved(percantage: $percantage) {
            DataItemView(triggerTransition: $triggerTransition)
        }
        .mask(
            maskGradient
                .frame(maxHeight: .infinity)
                .animation(.spring, value: percantage)
        )
    }
    
    @ViewBuilder
    private var maskGradient: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(1 - percantage.y),
                Color.black.opacity(0.5),
                Color.black.opacity(percantage.y)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct StyledButton: View {
    
    var text: String
    var function: () -> Void
    
    init(_ text: String, _ function: @escaping () -> Void) {
        self.text = text
        self.function = function
    }
    
    var body: some View {
        Button{
            function()
        } label: {
            ZStack {
                HStack {
                    Text("[")
                    Spacer()
                    Text("]")
                }
                Text(text)
                    .padding(20)
                
            }
        }
        .padding(.vertical, -20)
        .frame(maxWidth: .infinity)
        
        .textCase(.uppercase)
    }
}

// MARK: - Data Item View
struct DataItemView: View {
    @EnvironmentObject var viewModel: DITViewModel
    @Binding var triggerTransition: Bool
    
    let baseAnimationDelay = 0.1
    
    enum DITProperty: String, CaseIterable {
        case id, name, description, image, state, wallet_address, device_id, model_name, screen_size, os_version, last_update, dit_hash
        
        var isEditable: Bool {
            switch self {
            case .description, .name:
                return true
            default:
                return false
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(Array(DITProperty.allCases.enumerated()), id: \.element) { index, property in
                    DITPropertyRow(
                        property: property,
                        viewModel: viewModel,
                        triggerTransition: $triggerTransition,
                        baseAnimationDelay: baseAnimationDelay * Double(index) // Staggered delay
                    )
                }
            }
            .textCase(.uppercase)
            .lineLimit(1)
            .allowsTightening(true)
            .truncationMode(.tail)
        }
    }
}

struct DITPropertyRow: View {
    let property: DataItemView.DITProperty
    @ObservedObject var viewModel: DITViewModel
    @Binding var triggerTransition: Bool
    let baseAnimationDelay: Double
    
    var body: some View {
        HStack {
            AnimatedText(property.rawValue, delay: baseAnimationDelay, triggerTransition: $triggerTransition)
                .frame(maxWidth: .infinity, alignment: .leading)
            AnimatedText("//", delay: baseAnimationDelay + 0.03, triggerTransition: $triggerTransition)
            Group {
                if property.isEditable {
                    AnimatedTextField(property.rawValue, value: binding(for: property), delay: baseAnimationDelay + 0.04, triggerTransition: $triggerTransition)
                } else {
                    AnimatedText(value(for: property), delay: baseAnimationDelay + 0.04, triggerTransition: $triggerTransition)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(property.rawValue): \(value(for: property))")
    }
    
    private func value(for property: DataItemView.DITProperty) -> String {
        switch property {
        case .id: return viewModel.dit.id
        case .name: return viewModel.dit.name
        case .description: return viewModel.dit.description
        case .image: return viewModel.dit.image
        case .state: return viewModel.dit.state
        case .wallet_address: return viewModel.dit.wallet_address
        case .device_id: return viewModel.dit.device_id
        case .model_name: return viewModel.dit.model_name
        case .screen_size: return viewModel.dit.screen_size
        case .os_version: return viewModel.dit.os_version
        case .last_update: return viewModel.dit.last_update
        case .dit_hash: return viewModel.dit.dit_hash
        }
    }
    
    private func binding(for property: DataItemView.DITProperty) -> Binding<String> {
        switch property {
        case .description:
            return $viewModel.dit.description
        case .name:
            return $viewModel.dit.name
        default:
            fatalError("Binding not implemented for non-editable property: \(property.rawValue)")
        }
    }
}

struct AnimatedText: View {
    let text: String
    let delay: Double
    @Binding var triggerTransition: Bool
    
    init(_ text: String, delay: Double, triggerTransition: Binding<Bool>) {
        self.text = text
        self.delay = delay
        self._triggerTransition = triggerTransition
    }
    
    var body: some View {
        Text(text)
            .modifier(AnimatedTextModifier(delay: delay, triggerTransition: $triggerTransition))
    }
}

struct AnimatedTextField: View {
    let text: String
    @Binding var value: String
    let delay: Double
    @Binding var triggerTransition: Bool
    
    init(_ text: String, value: Binding<String>, delay: Double, triggerTransition: Binding<Bool>) {
        self.text = text
        self.delay = delay
        self._triggerTransition = triggerTransition
        self._value = value
    }
    
    var body: some View {
        TextField(text, text: $value)
            .modifier(AnimatedTextModifier(delay: delay, triggerTransition: $triggerTransition))
    }
}

struct AnimatedTextModifier: ViewModifier {
    let delay: Double
    @Binding var triggerTransition: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(triggerTransition ? 1 : 0)
            .mask(
                GeometryReader { geo in
                    Color.black
                        .offset(x: triggerTransition ? 0 : -geo.size.width)
                }
            )
            .offset(x: triggerTransition ? 0 : -10)
            .animation(
                triggerTransition
                ? .easeInOut(duration: 0.5).delay(delay)
                : .easeInOut,
                value: triggerTransition
            )
    }
}

#Preview {
    ContentView()
}
