import SwiftUI

// MARK: - Models
struct Seat: Identifiable {
    let id: String
    let row: Int
    let column: Int
    let available: Bool
    let type: SeatType
    let tier: SeatTier
    let price: Double

    enum SeatType {
        case standard, recliner, accessible
    }

    enum SeatTier {
        case regular, premium, vip
    }
}

// MARK: - Approach 1: Persistent Scroll Indicators with Fade Hints
struct SeatMapView_PersistentIndicators: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    @State private var scrollPosition: CGPoint = .zero

    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    SeatGridView(seats: seats, maxRow: maxRow, maxColumn: maxColumn)
                        .background(GeometryReader { geometry in
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                                  value: geometry.frame(in: .named("scroll")).origin)
                        })
                }
//                .frame(height: 500)
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollPosition = value
                }
                .defaultScrollAnchor(.center)
            }

            // Persistent gradient overlays to indicate scrollability (all 4 edges)
            // Top edge
            VStack {
                LinearGradient(
                    colors: [.black.opacity(0.3), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 40)
                .allowsHitTesting(false)
                Spacer()
            }

            // Bottom edge
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.black.opacity(0.3), .clear],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 40)
                .allowsHitTesting(false)
            }

            // Leading edge
            HStack {
                LinearGradient(
                    colors: [.black.opacity(0.3), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 40)
                .allowsHitTesting(false)
                Spacer()
            }

            // Trailing edge
            HStack {
                Spacer()
                LinearGradient(
                    colors: [.black.opacity(0.3), .clear],
                    startPoint: .trailing,
                    endPoint: .leading
                )
                .frame(width: 40)
                .allowsHitTesting(false)
            }
        }
        .frame(height: 500)
    }
}

// MARK: - Approach 2: Animated Arrow Indicators
struct SeatMapView_AnimatedArrows: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    @State private var arrowOpacity: Double = 1.0

    var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                SeatGridView(seats: seats, maxRow: maxRow, maxColumn: maxColumn)
            }
            .frame(width: 300, height: 500)
            .defaultScrollAnchor(.center)

            // Animated corner indicator (bottom-right with 4 arrows)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up")
                                .font(.caption)
                            Image(systemName: "arrow.left")
                                .font(.caption)
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down")
                                .font(.caption)
                            Image(systemName: "arrow.right")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    .opacity(arrowOpacity)
                    .padding()
                }
            }
            .frame(width: 300, height: 500)
        }
        .frame(width: 300, height: 500)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                arrowOpacity = 0.3
            }
        }
    }
}

// MARK: - Approach 3: Rail/Track Indicators
struct SeatMapView_RailIndicators: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                SeatGridView(seats: seats, maxRow: maxRow, maxColumn: maxColumn)
            }
            .frame(width: 300, height: 500)
            .defaultScrollAnchor(.center)

            // Vertical rail on left edge
            VStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 4)
                    .padding(.vertical, 20)
            }
            .frame(width: 300, height: 500, alignment: .leading)
            .padding(.leading, 4)
            .allowsHitTesting(false)

            // Vertical rail on right edge
            VStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 4)
                    .padding(.vertical, 20)
            }
            .frame(width: 300, height: 500, alignment: .trailing)
            .padding(.trailing, 4)
            .allowsHitTesting(false)

            // Horizontal rail on top edge
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 4)
                    .padding(.horizontal, 20)
            }
            .frame(width: 300, height: 500, alignment: .top)
            .padding(.top, 4)
            .allowsHitTesting(false)

            // Horizontal rail on bottom edge
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 4)
                    .padding(.horizontal, 20)
            }
            .frame(width: 300, height: 500, alignment: .bottom)
            .padding(.bottom, 4)
            .allowsHitTesting(false)
        }
        .frame(width: 300, height: 500)
    }
}

// MARK: - Approach 4: Mini Map Overview
struct SeatMapView_MiniMap: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    @State private var scrollOffset: CGPoint = .zero

    var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                SeatGridView(seats: seats, maxRow: maxRow, maxColumn: maxColumn)
                    .background(GeometryReader { geometry in
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                              value: geometry.frame(in: .named("scroll")).origin)
                    })
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            .defaultScrollAnchor(.center)

            // Mini map in corner
            VStack {
                HStack {
                    Spacer()
                    MiniMapView(
                        maxRow: maxRow,
                        maxColumn: maxColumn,
                        scrollOffset: scrollOffset,
                        viewportSize: CGSize(width: 360, height: 400)
                    )
                    .frame(width: 80, height: 60)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .padding()
                }
                Spacer()
            }
            .frame(width: 360, height: 400)
        }
        .frame(width: 360, height: 400)
    }
}

// MARK: - Approach 5: Pulse Effect on Edges
struct SeatMapView_PulseEdges: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                SeatGridView(seats: seats, maxRow: maxRow, maxColumn: maxColumn)
            }
            .frame(width: 300, height: 500)
            .defaultScrollAnchor(.center)

            // Pulsing indicators on all 4 corners
            // Top-left
            VStack {
                HStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(0.6), .clear],
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(pulseScale)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
            .frame(width: 300, height: 400)

            // Top-right
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(0.6), .clear],
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(pulseScale)
                        .padding()
                }
                Spacer()
            }
            .frame(width: 300, height: 400)

            // Bottom-left
            VStack {
                Spacer()
                HStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(0.6), .clear],
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(pulseScale)
                        .padding()
                    Spacer()
                }
            }
            .frame(width: 300, height: 500)

            // Bottom-right
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(0.6), .clear],
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(pulseScale)
                        .padding()
                }
            }
            .frame(width: 300, height: 500)
        }
        .frame(width: 300, height: 500)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.5
            }
        }
    }
}

// MARK: - Approach 6: flash Indicators
struct SeatMapView_FlashIndicators: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    @State private var flashTrigger = false
    @State private var hasInteracted = false

    var body: some View {
        VStack {
            VStack {
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    SeatGridView(seats: seats, maxRow: maxRow, maxColumn: maxColumn)
                }
                .scrollIndicatorsFlash(trigger: flashTrigger)
                .defaultScrollAnchor(.center)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !hasInteracted {
                                hasInteracted = true
                                print("User interacted - stopping flash")
                            }
                        }
                )
                .onAppear {
                    startFlashing()
                }
            }
            .frame(height: 400)
            .padding(.horizontal, 10)
            
            Text("Scroll to view more seats")
                .opacity(hasInteracted ? 0 : 1)
        }
    }

    private func startFlashing() {
        guard !hasInteracted else { return }

        // Flash immediately
        flashTrigger.toggle()

        print("Flash triggered: \(flashTrigger)")

        // Continue flashing every 2 seconds until user interacts
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if !hasInteracted {
                startFlashing()
            }
        }
    }
}

// MARK: - Supporting Views
struct SeatGridView: View {
    let seats: [Seat]
    let maxRow: Int
    let maxColumn: Int

    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<maxRow, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<maxColumn, id: \.self) { col in
                        if let seat = seats.first(where: { $0.row == row && $0.column == col }) {
                            SeatView(seat: seat)
                        } else {
                            Color.clear.frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
        .padding(40)
    }
}

struct SeatView: View {
    let seat: Seat

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(seat.available ? Color.green : Color.gray)
            .frame(width: 25, height: 25)
            .overlay(
                Text("\(seat.row)\(seat.column)")
                    .font(.caption2)
                    .foregroundColor(.white)
            )
    }
}

struct MiniMapView: View {
    let maxRow: Int
    let maxColumn: Int
    let scrollOffset: CGPoint
    let viewportSize: CGSize

    // Calculate content size (approximate based on seat size + spacing + padding)
    private var contentSize: CGSize {
        let seatSize: CGFloat = 25
        let spacing: CGFloat = 8
        let padding: CGFloat = 80 // 40 padding on each side
        let width = CGFloat(maxColumn) * (seatSize + spacing) - spacing + padding
        let height = CGFloat(maxRow) * (seatSize + spacing) - spacing + padding
        return CGSize(width: width, height: height)
    }

    // Calculate viewport rectangle on minimap
    private var viewportRect: CGRect {
        let miniMapSize = CGSize(width: 80, height: 60)
        let scaleX = miniMapSize.width / contentSize.width
        let scaleY = miniMapSize.height / contentSize.height

        let width = viewportSize.width * scaleX
        let height = viewportSize.height * scaleY

        // When centered (scrollOffset = 0), viewport should be centered on minimap
        // As we scroll, viewport moves proportionally
        let centerX = (miniMapSize.width - width) / 2
        let centerY = (miniMapSize.height - height) / 2

        // scrollOffset is the content's origin in the coordinate space
        // Negative values mean content moved left/up (scrolled right/down)
        let x = -(centerX + (scrollOffset.x * scaleX))
        let y = -(centerY + (scrollOffset.y * scaleY))

        return CGRect(x: x, y: y, width: width, height: height)
    }

    var body: some View {
        ZStack {
            // Full seat map representation
            VStack(spacing: 1) {
                ForEach(0..<min(maxRow, 10), id: \.self) { _ in
                    HStack(spacing: 1) {
                        ForEach(0..<min(maxColumn, 15), id: \.self) { _ in
                            Rectangle()
                                .fill(Color.green.opacity(0.5))
                                .frame(width: 4, height: 4)
                        }
                    }
                }
            }

            // Viewport indicator
            Rectangle()
                .strokeBorder(Color.white, lineWidth: 2)
                .background(Color.white.opacity(0.2))
                .frame(width: viewportRect.width, height: viewportRect.height)
                .offset(x: viewportRect.minX, y: viewportRect.minY)
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

// MARK: - Demo View
struct SeatMapDemoView: View {
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
//            SeatMapView_PersistentIndicators(seats: sampleSeats, maxRow: 20, maxColumn: 30)
//                .tabItem { Label("Gradient Overlays", systemImage: "1.circle") }

//            SeatMapView_AnimatedArrows(seats: sampleSeats, maxRow: 20, maxColumn: 30)
//                .tabItem { Label("Animated Arrows", systemImage: "2.circle") }

//            SeatMapView_RailIndicators(seats: sampleSeats, maxRow: 20, maxColumn: 30)
//                .tabItem { Label("Rail Tracks", systemImage: "3.circle") }

            SeatMapView_MiniMap(seats: sampleSeats, maxRow: 20, maxColumn: 30)
                .tabItem { Label("Mini Map", systemImage: "1.circle") }

//            SeatMapView_PulseEdges(seats: sampleSeats, maxRow: 20, maxColumn: 30)
//                .tabItem { Label("Pulse Effect", systemImage: "5.circle") }
            
            SeatMapView_FlashIndicators(seats: sampleSeats, maxRow: 20, maxColumn: 30)
                .tabItem { Label("Flash Effect", systemImage: "2.circle") }
        }
    }
}

#Preview {
    SeatMapDemoView()
}
