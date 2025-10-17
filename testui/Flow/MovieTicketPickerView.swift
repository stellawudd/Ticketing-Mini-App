//
//  MovieTicketPickerView.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

struct MovieTicketPickerView: View {
    @ObservedObject var coordinator: CheckoutFlowViewModel
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Ticket Picker")
                .font(.title)

            Text("Selected Seat: \(coordinator.selectedSeat ?? "None")")

            Button("Select Adult Ticket") {
                coordinator.selectedTicketType = "Adult"
            }

            Button("Select Child Ticket") {
                coordinator.selectedTicketType = "Child"
            }

            if let ticketType = coordinator.selectedTicketType {
                Text("Selected: \(ticketType)")
            }

            if isLoading {
                ProgressView("Creating hold...")
            }

            Button("Continue") {
                Task {
                    isLoading = true
                    await coordinator.startCheckoutFlow()
                    isLoading = false
                }
            }
            .disabled(coordinator.selectedTicketType == nil || isLoading)
        }
        .padding()
        .navigationBarTitle("Select Ticket")
    }
}
