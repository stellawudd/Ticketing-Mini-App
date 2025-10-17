//
//  SeatMapView.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

struct SeatMapView: View {
    @ObservedObject var coordinator: CheckoutFlowViewModel

    var body: some View {
        VStack {
            Text("SeatMapView")
                .padding()

            Text("Selected Seat: \(coordinator.selectedSeat ?? "None")")

            Button("Select Seat A1") {
                coordinator.selectedSeat = "A1"
            }

            Button("Continue") {
                coordinator.navigateToTicketPicker()
            }
        }
        .navigationBarTitle("Select Seat")
    }
}

class MovieSeatAndTicketPickerViewModel: ObservableObject {
    var input: SeatMapAndPickerInput

    init(input: SeatMapAndPickerInput) {
        self.input = input
    }
}

#Preview {
    NavigationStack {
        SeatMapView(coordinator: CheckoutFlowViewModel(input: .init(offerConcessions: true)))
    }
}
