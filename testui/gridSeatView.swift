import SwiftUI

// MARK: - Grid-based Seat Map Implementation

struct GridSeatMapView: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    // Create fixed-size columns for the grid
    private var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(25), spacing: 8), count: maxColumn)
    }

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<maxRow, id: \.self) { row in
                    ForEach(0..<maxColumn, id: \.self) { col in
                        if let seat = seats.first(where: { $0.row == row && $0.column == col }) {
                            SeatView(seat: seat)
                        } else {
                            // Empty seat placeholder (for aisles)
                            Color.clear
                                .frame(width: 25, height: 25)
                        }
                    }
                }
            }
            .padding(40)
        }
        .frame(width: 360, height: 400)
        .defaultScrollAnchor(.center)
    }
}

// MARK: - Alternative: ScrollView with LazyVGrid (more control)
struct GridSeatMapView_Alternative: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    private var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(25), spacing: 8), count: maxColumn)
    }

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            // Wrap in a container to control total size
            LazyVGrid(columns: columns, spacing: 8) {
                // Create all grid items in order
                ForEach(allGridItems, id: \.id) { item in
                    if let seat = item.seat {
                        SeatView(seat: seat)
                    } else {
                        Color.clear
                            .frame(width: 25, height: 25)
                    }
                }
            }
            .padding(40)
        }
        .frame(width: 360, height: 400)
        .defaultScrollAnchor(.center)
    }

    // Create ordered grid items for LazyVGrid
    private var allGridItems: [GridItemData] {
        var items: [GridItemData] = []
        for row in 0..<maxRow {
            for col in 0..<maxColumn {
                let seat = seats.first(where: { $0.row == row && $0.column == col })
                items.append(GridItemData(id: "\(row)-\(col)", seat: seat))
            }
        }
        return items
    }

    struct GridItemData: Identifiable {
        let id: String
        let seat: Seat?
    }
}

// MARK: - Most Efficient: Pre-computed Grid Array
struct GridSeatMapView_Optimized: View {
    let seatGrid: [[Seat?]]  // 2D array: seatGrid[row][col]

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            LazyVStack(spacing: 8) {
                ForEach(Array(seatGrid.enumerated()), id: \.offset) { rowIndex, row in
                    LazyHStack(spacing: 8) {
                        ForEach(Array(row.enumerated()), id: \.offset) { colIndex, seat in
                            if let seat = seat {
                                SeatView(seat: seat)
                            } else {
                                Color.clear
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                }
            }
            .padding(40)
        }
        .frame(width: 360, height: 400)
        .defaultScrollAnchor(.center)
    }

    // Helper to convert flat array to 2D grid
    static func createGrid(from seats: [Seat], maxRow: Int, maxColumn: Int) -> [[Seat?]] {
        var grid: [[Seat?]] = Array(repeating: Array(repeating: nil, count: maxColumn), count: maxRow)

        for seat in seats {
            if seat.row < maxRow && seat.column < maxColumn {
                grid[seat.row][seat.column] = seat
            }
        }

        return grid
    }
}

// MARK: - Demo View
struct GridSeatMapDemoView: View {
    let sampleSeats = (0..<20).flatMap { row in
        (0..<30).map { col in
            Seat(
                id: "\(row)-\(col)",
                row: row,
                column: col,
                available: Bool.random(),
                type: .standard,
                tier: .regular,
                price: 12.99
            )
        }
    }

    var body: some View {
        TabView {
            GridSeatMapView(seats: sampleSeats, maxRow: 20, maxColumn: 30)
                .tabItem { Label("LazyVGrid Basic", systemImage: "1.circle") }

            GridSeatMapView_Alternative(seats: sampleSeats, maxRow: 20, maxColumn: 30)
                .tabItem { Label("LazyVGrid Alt", systemImage: "2.circle") }

            GridSeatMapView_Optimized(
                seatGrid: GridSeatMapView_Optimized.createGrid(
                    from: sampleSeats,
                    maxRow: 20,
                    maxColumn: 30
                )
            )
            .tabItem { Label("LazyVStack+HStack", systemImage: "3.circle") }
        }
    }
}

#Preview {
    GridSeatMapDemoView()
}
