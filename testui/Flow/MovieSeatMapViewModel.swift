//
//  MovieSeatMapViewModel.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

class MovieSeatMapViewModel: ObservableObject {
    var coordinator: CheckoutFlowViewModel
    @Published var availableSeats: [String] = ["A1", "A2", "A3", "B1", "B2", "B3"]

    init(coordinator: CheckoutFlowViewModel) {
        self.coordinator = coordinator
    }

    func selectSeat(_ seat: String) {
        coordinator.selectedSeat = seat
    }

    func onContinue() {
        guard coordinator.selectedSeat != nil else { return }
        coordinator.navigateToTicketPicker()
    }
}
