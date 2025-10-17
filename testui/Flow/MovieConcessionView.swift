//
//  MovieConcessionView.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

struct MovieConcessionView: View {
    @ObservedObject var coordinator: CheckoutFlowViewModel
    @StateObject private var viewModel: MovieConcessionViewModel

    init(coordinator: CheckoutFlowViewModel) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: MovieConcessionViewModel(coordinator: coordinator))
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Concessions")
                .font(.title)
                .padding()

            if viewModel.remainingTime > 0 {
                Text("Time remaining: \(Int(viewModel.remainingTime))s")
                    .foregroundColor(.red)
                    .font(.headline)
            }

            Text("Seat: \(coordinator.selectedSeat ?? "None") | Ticket: \(coordinator.selectedTicketType ?? "None")")
                .foregroundColor(.secondary)
                .font(.caption)

            if viewModel.isLoading {
                ProgressView("Loading concessions...")
            } else {
                ForEach(viewModel.availableConcessions) { item in
                    Button("\(item.name) - $\(String(format: "%.2f", item.price))") {
                        viewModel.addConcession(item.name)
                    }
                    .buttonStyle(.bordered)
                }
            }

            if !coordinator.selectedConcessions.isEmpty {
                Text("Selected: \(coordinator.selectedConcessions.joined(separator: ", "))")
                    .foregroundColor(.green)
            }

            Spacer()

            Button("Continue to Checkout") {
                viewModel.onContinue()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationBarTitle("Concessions")
        .task {
            await viewModel.fetchConcessions()
            viewModel.startCountdownTimer()
        }
    }
}

