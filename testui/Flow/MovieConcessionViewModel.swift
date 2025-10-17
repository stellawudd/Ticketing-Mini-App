//
//  MovieConcessionViewModel.swift
//  Copyright © 2025 DoorDash. All rights reserved.
//

import SwiftUI

@MainActor
class MovieConcessionViewModel: ObservableObject {
    var coordinator: CheckoutFlowViewModel
    @Published var availableConcessions: [ConcessionItem] = []
    @Published var isLoading = false
    @Published var remainingTime: TimeInterval = 0

    init(coordinator: CheckoutFlowViewModel) {
        self.coordinator = coordinator
    }

    func fetchConcessions() async {
        isLoading = true
        await coordinator.fetchConcessionsIfNeeded()

        // Simulate loading concessions
        try? await Task.sleep(nanoseconds: 500_000_000)

        await MainActor.run {
            availableConcessions = [
                ConcessionItem(name: "Popcorn", price: 8.99),
                ConcessionItem(name: "Soda", price: 5.99),
                ConcessionItem(name: "Candy", price: 4.99)
            ]
            isLoading = false
        }
    }

    func addConcession(_ item: String) {
        coordinator.selectedConcessions.append(item)
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

    func onContinue() {
        coordinator.navigateToCheckout()
    }
}

struct ConcessionItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
}
