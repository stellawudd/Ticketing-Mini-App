//
//  MovieDetailsView.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//
import SwiftUI

struct MovieDetailsView: View {
    @StateObject var viewModel: MovieDetailsViewModel = .init()
    @State private var showCheckoutFlow = false

    var body: some View {
        VStack {
            Text("Movie Details View")
                .padding()

            Button("Time slot") {
                showCheckoutFlow = true
            }
        }
        .fullScreenCover(isPresented: $showCheckoutFlow) {
            CheckoutFlowRootView(
                input: SeatMapAndPickerInput(offerConcessions: true),
                onDismiss: {
                    showCheckoutFlow = false
                }
            )
        }
    }
}

// Root view for the entire checkout flow with its own NavigationStack
struct CheckoutFlowRootView: View {
    @StateObject private var coordinator: CheckoutFlowViewModel
    let onDismiss: () -> Void

    init(input: SeatMapAndPickerInput, onDismiss: @escaping () -> Void) {
        _coordinator = StateObject(wrappedValue: CheckoutFlowViewModel(input: input))
        self.onDismiss = onDismiss
    }

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            SeatMapView(coordinator: coordinator)
                .navigationDestination(for: TicketingDestination.self) { destination in
                    destinationView(for: destination)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for destination: TicketingDestination) -> some View {
        switch destination {
        case .ticketPicker:
            MovieTicketPickerView(coordinator: coordinator)

        case .concession:
            MovieConcessionView(coordinator: coordinator)

        case .checkout:
            MovieCheckoutView(coordinator: coordinator, onDismiss: onDismiss)
        }
    }
}

struct SeatMapAndPickerInput: Hashable {
    var offerConcessions: Bool
}

class MovieDetailsViewModel: ObservableObject {
    
    func onTimeSlotTapped(completion: (SeatMapAndPickerInput) -> Void) {
        let input = SeatMapAndPickerInput(offerConcessions: true)
        completion(input)
    }
}

#Preview {
    MovieDetailsView()
}
