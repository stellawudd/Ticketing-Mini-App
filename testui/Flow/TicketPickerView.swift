////
////  TicketPickerView.swift
////  Copyright © 2025 DoorDash. All rights reserved.
////
//
//import SwiftUI
//
//struct MovieTicketPickerView: View {
//    @ObservedObject private var viewModel: MovieSeatAndTicketPickerViewModel
//    @Binding var navigationPath: NavigationPath
//    
//    init(viewModel: MovieSeatAndTicketPickerViewModel, navigationPath: Binding<NavigationPath>) {
//        self.viewModel = viewModel
//        _navigationPath = navigationPath  // ← Note the underscore for @Binding
//    }
//            
//    var body: some View {
//        VStack {
//            Text("MovieTicketPickerView")
//                .padding()
//            
//            Button("Continue") {
//                Task {
//                    await startCheckout()
//                }
//            }
//        }
//    }
//    
//    private func startCheckout() async {
////        guard let checkoutInput = viewModel.prepareCheckoutInput() else {
////            return
////        }
////        
////        isStartingCheckout = true
////        
////        print("🎬 Creating CheckoutFlowViewModel...")
////        let coordinator = CheckoutFlowViewModel()
//        
//        print("🎬 Starting checkout flow (creating hold, starting timer)...")
////        await coordinator.startCheckoutFlow()
//        
////        isStartingCheckout = false
////        
////        guard coordinator.holdResponse != nil else {
////            print("❌ Hold creation failed")
////            return
////        }
////        
////        print("✅ Hold created, navigating to: \(checkoutInput.offerConcessions ? "Concession" : "Checkout")")
//        
//        // Navigate using shared path
////        if viewModel.input.offerConcessions {
////            navigationPath.append(TicketingDestination.concession(coordinator))
////        } else {
////            navigationPath.append(TicketingDestination.checkout(coordinator))
////        }
//    }
//}
//
//#Preview {
//    MovieTicketPickerView(viewModel: .init(input: .init(offerConcessions: true)), navigationPath: .constant(.init()))
//}
