//
//  SeatMapView.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

struct SeatMapView: View {
    @ObservedObject var coordinator: CheckoutFlowViewModel
    @StateObject private var viewModel: MovieSeatMapViewModel

    init(coordinator: CheckoutFlowViewModel) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: MovieSeatMapViewModel(coordinator: coordinator))
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Seat")
                .font(.title)
                .padding()

            Text("Selected Seat: \(coordinator.selectedSeat ?? "None")")
                .foregroundColor(.secondary)

            ForEach(viewModel.availableSeats, id: \.self) { seat in
                Button(seat) {
                    viewModel.selectSeat(seat)
                }
                .buttonStyle(.bordered)
                .tint(coordinator.selectedSeat == seat ? .blue : .gray)
            }

            Spacer()

            Button("Continue to Tickets") {
                viewModel.onContinue()
            }
            .disabled(coordinator.selectedSeat == nil)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationBarTitle("Select Seat")
    }
}

#Preview {
    NavigationStack {
        SeatMapView(coordinator: CheckoutFlowViewModel(input: .init(offerConcessions: true)))
    }
}
