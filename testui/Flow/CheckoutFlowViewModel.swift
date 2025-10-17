//
//  CheckoutFlowViewModel.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

class CheckoutFlowViewModel: ObservableObject {
    let id = UUID()
    @Published var navigationPath = NavigationPath()
    var input: SeatMapAndPickerInput

    // User selections stored here
    @Published var selectedSeat: String?
    @Published var selectedTicketType: String?
    @Published var countdownExpireDate: Date?
    @Published var selectedConcessions: [String] = []
    @Published var holdId: String?

    init(input: SeatMapAndPickerInput) {
        self.input = input
    }

    func navigateToTicketPicker() {
        navigationPath.append(TicketingDestination.ticketPicker)
    }

    func navigateToConcession() {
        navigationPath.append(TicketingDestination.concession)
    }

    func navigateToCheckout() {
        navigationPath.append(TicketingDestination.checkout)
    }

    // Called after ticket selection - creates hold and starts timer
    func startCheckoutFlow() async {
        // TODO: Call BE endpoint to create hold
        // Simulate API call
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        // Set expiration (e.g., 10 minutes from now)
        await MainActor.run {
            self.countdownExpireDate = Date().addingTimeInterval(600)
            self.holdId = UUID().uuidString

            // Navigate based on offerConcessions
            if input.offerConcessions {
                navigateToConcession()
            } else {
                navigateToCheckout()
            }
        }
    }

    func fetchConcessionsIfNeeded() async {
        // TODO: Fetch concessions from BE if needed
    }

    func stopTimer() {
        countdownExpireDate = nil
    }

    func resetFlow() {
        navigationPath = NavigationPath()
        selectedSeat = nil
        selectedTicketType = nil
        countdownExpireDate = nil
        selectedConcessions = []
        holdId = nil
    }
}
