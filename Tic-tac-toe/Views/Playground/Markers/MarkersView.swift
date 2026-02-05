//
//  MarkersView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import SwiftUI

// MARK: - MarkersView
struct MarkersView: View {

    var body: some View {
        VStack {
            ZStack {
                MarkerLine()
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(
                            lineWidth: 14,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-45))
                MarkerLine()
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(
                            lineWidth: 14,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(45))
            }
            OpenMarkerCircle()
                .stroke(
                    Color.red,
                    style: StrokeStyle(
                        lineWidth: 14,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
        }
    }
}

// MARK: - MarkerLine
struct MarkerLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.midY),
            control1: CGPoint(x: rect.width * 0.3, y: rect.midY - 5),
            control2: CGPoint(x: rect.width * 0.7, y: rect.midY + 5)
        )
        return path
    }
}

// MARK: - OpenMarkerCircle
struct OpenMarkerCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        let segments = 24
        let angleStep = (2 * .pi) / CGFloat(segments)

        var prevPoint: CGPoint?

        for i in 0 ..< segments {
            let angle = angleStep * CGFloat(i)

            let wobble: CGFloat = 0.0
            let r = radius + wobble

            let point = CGPoint(
                x: center.x + cos(angle) * r - (CGFloat(i) * 0.4),
                y: center.y + sin(angle) * r - (CGFloat(i) * 0.4)
            )

            if i == 0 {
                path.move(to: point)
            } else if let prev = prevPoint {
                let control = CGPoint(
                    x: (prev.x + point.x) / 2,
                    y: (prev.y + point.y) / 2
                )

                path.addQuadCurve(to: point, control: control)
            }

            prevPoint = point
        }

        return path
    }
}

// MARK: - DrawnShape
struct DrawnShape<S: Shape>: View {
    let shape: S
    let color: Color
    let lineWidth: CGFloat
    let duration: Double

    @State private var progress: CGFloat = 0

    var body: some View {
        shape
            .trim(from: 0, to: progress)
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .onAppear {
                withAnimation(.easeInOut(duration: duration)) {
                    progress = 1
                }
            }
    }
}

// MARK: - AnimatedXMarker
struct AnimatedXMarker: View {
    @State private var secondLine = false

    var size: CGFloat = 75.0
    var lineWidth: CGFloat {
        size / 5
    }

    var body: some View {
        ZStack {
            DrawnShape(
                shape: MarkerLine(),
                color: .blue,
                lineWidth: lineWidth,
                duration: 0.25
            )
            .frame(width: size, height: size)
            .rotationEffect(.degrees(-45))

            if secondLine {
                DrawnShape(
                    shape: MarkerLine(),
                    color: .blue,
                    lineWidth: lineWidth,
                    duration: 0.25
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(45))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                secondLine = true
            }
        }
    }
}

// MARK: - AnimatedOMarker
struct AnimatedOMarker: View {

    var size: CGFloat = 75.0

    var lineWidth: CGFloat {
        size / 5
    }

    var body: some View {
        DrawnShape(
            shape: OpenMarkerCircle(),
            color: .red,
            lineWidth: lineWidth,
            duration: 0.5
        )
        .frame(width: size, height: size)
        .rotationEffect(.degrees(-90))
    }
}



#Preview {
    HStack {
        AnimatedXMarker()
        AnimatedOMarker()
    }
}
