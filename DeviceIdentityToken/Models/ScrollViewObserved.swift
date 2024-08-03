//
//  ScrollViewObserved.swift
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 12/07/2024.
//

import SwiftUI
import UIKit

struct ScrollViewObserved<Content: View>: UIViewRepresentable {
    let axes: Axis.Set
    let showsIndicators: Bool
    @Binding var offset: CGPoint
    @Binding var percantage: CGPoint
    @Binding var isScrolling: Bool
    @Binding var scrolledToTop: Bool
    @Binding var scrolledToBottom: Bool
    
    let content: () -> Content
    
    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offset: Binding<CGPoint>? = nil,
        percantage: Binding<CGPoint>? = nil,
        isScrolling: Binding<Bool>? = nil,
        scrolledToTop: Binding<Bool>? = nil,
        scrolledToBottom: Binding<Bool>? = nil,
        content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._offset = offset ?? .constant(.zero)
        self._percantage = percantage ?? .constant(.zero)
        self._isScrolling = isScrolling ?? .constant(false)
        self._scrolledToBottom = scrolledToBottom ?? .constant(false)
        self._scrolledToTop = scrolledToTop ?? .constant(false)
        self.content = content
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = showsIndicators
        scrollView.showsHorizontalScrollIndicator = showsIndicators
        scrollView.delegate = context.coordinator
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = axes.contains(.vertical)
        scrollView.alwaysBounceHorizontal = axes.contains(.horizontal)
        
        let hostingController = context.coordinator.hostingController
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        scrollView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: axes.contains(.horizontal) ? 1 : 1)
        ])

        if !axes.contains(.vertical) {
            hostingController.view.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
        }
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let hostingController = context.coordinator.hostingController
        hostingController.rootView = content()
        hostingController.view.setNeedsLayout()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewObserved
        var hostingController: UIHostingController<Content>
        
        init(_ parent: ScrollViewObserved) {
            self.parent = parent
            self.hostingController = UIHostingController(rootView: parent.content())
            super.init()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let scrollOffset = scrollView.contentOffset
            let viewSize = scrollView.contentSize
            parent.offset = scrollOffset
            
            let xPercentage = viewSize.width > 0 
            ? scrollOffset.x / (viewSize.width - scrollView.frame.size.width)
            : 0
            let yPercentage = viewSize.height > 0
            ? scrollOffset.y / (viewSize.height - scrollView.frame.size.height)
            : 0
            
            parent.percantage = CGPoint(x: xPercentage, y: yPercentage)
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            parent.isScrolling = true
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.isScrolling = false
        }
    }
}
