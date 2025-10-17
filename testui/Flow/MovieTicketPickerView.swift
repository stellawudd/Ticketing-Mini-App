//
//  MovieTicketPickerView.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

struct MovieTicketPickerView: View {
    @ObservedObject var coordinator: CheckoutFlowViewModel
    @StateObject private var viewModel: MovieTicketPickerViewModel

    init(coordinator: CheckoutFlowViewModel) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: MovieTicketPickerViewModel(coordinator: coordinator))
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Ticket Type")
                .font(.title)
                .padding()

            Text("Selected Seat: \(coordinator.selectedSeat ?? "None")")
                .foregroundColor(.secondary)

            ForEach(viewModel.availableTicketTypes, id: \.self) { type in
                Button(type) {
                    viewModel.selectTicketType(type)
                }
                .buttonStyle(.bordered)
                .tint(coordinator.selectedTicketType == type ? .blue : .gray)
            }

            if let ticketType = coordinator.selectedTicketType {
                Text("Selected: \(ticketType)")
                    .foregroundColor(.green)
            }

            Spacer()

            if viewModel.isLoading {
                ProgressView("Creating hold...")
            }

            Button("Continue") {
                Task {
                    await viewModel.onContinue()
                }
            }
            .disabled(coordinator.selectedTicketType == nil || viewModel.isLoading)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationBarTitle("Select Ticket")
    }
}
