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
                .padding()

            if viewModel.remainingTime > 0 {
                Text("Time remaining: \(Int(viewModel.remainingTime))s")
                    .foregroundColor(.red)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Order Summary:")
                    .font(.headline)

                Text("Seat: \(coordinator.selectedSeat ?? "None")")
                Text("Ticket: \(coordinator.selectedTicketType ?? "None")")

                if !coordinator.selectedConcessions.isEmpty {
                    Text("Concessions: \(coordinator.selectedConcessions.joined(separator: ", "))")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            Spacer()

            if viewModel.isSubmitting {
                ProgressView("Submitting order...")
            }

            Button("Complete Purchase") {
                Task {
                    await viewModel.submitOrder()
                    onDismiss()
                }
            }
            .disabled(viewModel.isSubmitting)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationBarTitle("Checkout")
        .onAppear {
            viewModel.startCountdownTimer()
        }
    }
}


@MainActor
class MovieCheckoutViewModel: ObservableObject {
    var coordinator: CheckoutFlowViewModel
    @Published var isSubmitting = false
    @Published var remainingTime: TimeInterval = 0

    init(coordinator: CheckoutFlowViewModel) {
        self.coordinator = coordinator
    }

    func startCountdownTimer() {
        guard let expireDate = coordinator.countdownExpireDate else { return }
        remainingTime = expireDate.timeIntervalSinceNow

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.remainingTime = expireDate.timeIntervalSinceNow
            if self.remainingTime <= 0 {
                timer.invalidate()
            }
        }
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
