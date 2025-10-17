//
//  ContentView.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

//struct ContentView: View {
//    
//    var lst = Array(1...50)
//    
//    var body: some View {
//        VStack {
//            Text("Scroll in both directions")
//                .font(.headline)
//            
//            ScrollView([.horizontal, .vertical], showsIndicators: true) {
//                VStack(spacing: 20) {
//                    ForEach(0..<10) { row in
//                        HStack(spacing: 20) {
//                            ForEach(0..<5) { column in
//                                let index = row * 5 + column
//                                if index < lst.count {
//                                    Text("\(lst[index])")
//                                        .font(.system(size: 20, weight: .bold))
//                                        .frame(width: 80, height: 80)
//                                        .background(Color.blue.opacity(0.2))
//                                        .cornerRadius(10)
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding(20)
//            }
//            .frame(height: 500)
//            .background(
//                // Add a gradient border to indicate scrollability
//                RoundedRectangle(cornerRadius: 10)
//                    .strokeBorder(
//                        LinearGradient(
//                            gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)]),
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        ),
//                        lineWidth: 2
//                    )
//            )
//        }
//        .padding()
//    }
//}

import SwiftUI

struct ContentView: View {
    
    var lst = Array(1...50)
    @State private var scrollOffset: CGPoint = .zero
    
    var body: some View {
        VStack {
            Text("Scroll in both directions")
                .font(.headline)
            
            ScrollViewWithAlwaysVisibleIndicators(
                axes: [.horizontal, .vertical],
                showsIndicators: true,
                content: {
                    VStack(spacing: 20) {
                        ForEach(0..<10) { row in
                            HStack(spacing: 20) {
                                ForEach(0..<5) { column in
                                    let index = row * 5 + column
                                    if index < lst.count {
                                        Text("\(lst[index])")
                                            .font(.system(size: 20, weight: .bold))
                                            .frame(width: 80, height: 80)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            )
            .frame(height: 500)
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .strokeBorder(
//                        LinearGradient(
//                            gradient: Gradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)]),
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        ),
//                        lineWidth: 2
//                    )
//            )
        }
        .padding()
    }
}

struct ScrollViewWithAlwaysVisibleIndicators<Content: View>: UIViewRepresentable {
    var axes: Axis.Set
    var showsIndicators: Bool
    var content: Content
    
    init(axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        // Create a UIScrollView
        let scrollView = UIScrollView()
        
        // Configure the UIScrollView
        scrollView.showsVerticalScrollIndicator = axes.contains(.vertical) && showsIndicators
        scrollView.showsHorizontalScrollIndicator = axes.contains(.horizontal) && showsIndicators
        
        // Always show scroll indicators
//        scrollView.flashScrollIndicators()
        
        // Create and configure a UIHostingController to hold our SwiftUI content
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the hosting controller's view to the scroll view
        scrollView.addSubview(hostingController.view)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        ])
        
        // If horizontal scrolling is enabled, make the content view width flexible
        if axes.contains(.horizontal) {
            hostingController.view.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        } else {
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        }
        
        // If vertical scrolling is enabled, make the content view height flexible
        if axes.contains(.vertical) {
            hostingController.view.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
        } else {
            hostingController.view.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
        }
        
        // Permanently show scroll indicators
        scrollView.layer.setValue(true, forKey: "alwaysBounceVertical")
        scrollView.layer.setValue(true, forKey: "alwaysBounceHorizontal")
        scrollView.indicatorStyle = .default
        
        // Add indicator always visible
        context.coordinator.setupAlwaysVisibleIndicators(for: scrollView)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Update the hosting controller with new content
        if let hostingController = uiView.subviews.first?.next as? UIHostingController<Content> {
            hostingController.rootView = content
            hostingController.view.setNeedsLayout()
        }
        
        // Flash scroll indicators to make them visible
        uiView.flashScrollIndicators()
        
        // Ensure our indicator timer is active
        context.coordinator.setupAlwaysVisibleIndicators(for: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        private var indicatorTimer: Timer?
        
        func setupAlwaysVisibleIndicators(for scrollView: UIScrollView) {
            // Cancel any existing timer
            indicatorTimer?.invalidate()
            
            // Flash indicators immediately
            scrollView.flashScrollIndicators()
            
            // Set up a timer to periodically flash the indicators
            indicatorTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                scrollView.flashScrollIndicators()
                
                // Force scroll indicators to be visible
                for subview in scrollView.subviews {
                    if let indicator = subview as? UIImageView,
                       subview.frame.width < 10 || subview.frame.height < 10 {
                        indicator.alpha = 1.0
                    }
                }
            }
        }
        
        deinit {
            indicatorTimer?.invalidate()
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//#Preview {
//    ContentView()
//}
