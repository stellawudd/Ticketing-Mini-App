//
//  MovieConcessionView.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

struct MovieConcessionView: View {
    @ObservedObject var coordinator: CheckoutFlowViewModel
    @State private var remainingTime: TimeInterval = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Concessions")
                .font(.title)

            if remainingTime > 0 {
                Text("Time remaining: \(Int(remainingTime))s")
                    .foregroundColor(.red)
            }

            Text("Selected Seat: \(coordinator.selectedSeat ?? "None")")
            Text("Selected Ticket: \(coordinator.selectedTicketType ?? "None")")

            Button("Add Popcorn") {
                coordinator.selectedConcessions.append("Popcorn")
            }

            Button("Add Soda") {
                coordinator.selectedConcessions.append("Soda")
            }

            if !coordinator.selectedConcessions.isEmpty {
                Text("Selected: \(coordinator.selectedConcessions.joined(separator: ", "))")
            }

            Button("Continue to Checkout") {
                coordinator.navigateToCheckout()
            }
        }
        .padding()
        .navigationBarTitle("Concessions")
        .task {
            await coordinator.fetchConcessionsIfNeeded()
            startCountdown()
        }
    }

    private func startCountdown() {
        guard let expireDate = coordinator.countdownExpireDate else { return }
        remainingTime = expireDate.timeIntervalSinceNow

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            remainingTime = expireDate.timeIntervalSinceNow
            if remainingTime <= 0 {
                timer.invalidate()
            }
        }
    }
}

