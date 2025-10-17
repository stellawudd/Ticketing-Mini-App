//
//  Untitled.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

struct MovieCheckoutView: View {
    @ObservedObject var coordinator: CheckoutFlowViewModel
    @StateObject private var viewModel: MovieCheckoutViewModel
    let onDismiss: () -> Void

    init(coordinator: CheckoutFlowViewModel, onDismiss: @escaping () -> Void) {
        self.coordinator = coordinator
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: MovieCheckoutViewModel(coordinator: coordinator))
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Checkout")
                .font(.title)

            Text("Selected Seat: \(coordinator.selectedSeat ?? "None")")
            Text("Selected Ticket: \(coordinator.selectedTicketType ?? "None")")

            if !coordinator.selectedConcessions.isEmpty {
                Text("Concessions: \(coordinator.selectedConcessions.joined(separator: ", "))")
            }

            if viewModel.isSubmitting {
                ProgressView("Submitting order...")
            }

            Button("Complete Purchase") {
                Task {
                    await viewModel.submitOrder()
                    // On success, dismiss the entire flow
                    onDismiss()
                }
            }
            .disabled(viewModel.isSubmitting)
        }
        .padding()
        .navigationBarTitle("Checkout")
    }
}


class MovieCheckoutViewModel: ObservableObject {
    var coordinator: CheckoutFlowViewModel
    @Published var isSubmitting = false

    init(coordinator: CheckoutFlowViewModel) {
        self.coordinator = coordinator
    }

    func submitOrder() async {
        isSubmitting = true

        // TODO: Submit order to BE
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1s

        await MainActor.run {
            coordinator.stopTimer()
            coordinator.resetFlow()
            isSubmitting = false
        }
    }
}
