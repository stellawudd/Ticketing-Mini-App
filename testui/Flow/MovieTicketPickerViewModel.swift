//
//  MovieTicketPickerViewModel.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

@MainActor
class MovieTicketPickerViewModel: ObservableObject {
    var coordinator: CheckoutFlowViewModel
    @Published var isLoading = false
    @Published var availableTicketTypes = ["Adult", "Child", "Senior"]

    init(coordinator: CheckoutFlowViewModel) {
        self.coordinator = coordinator
    }

    func selectTicketType(_ type: String) {
        coordinator.selectedTicketType = type
    }

    func onContinue() async {
        guard coordinator.selectedTicketType != nil else { return }

        isLoading = true
        await coordinator.startCheckoutFlow()
        isLoading = false
    }
}
