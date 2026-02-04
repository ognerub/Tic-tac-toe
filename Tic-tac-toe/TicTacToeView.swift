//
//  TicTacToeView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import SwiftUI
import SwiftData

struct TicTacToeView: View {

    @StateObject private var viewModel = TicTacToeViewModel()

    var body: some View {
        TabView {
            playgroundView
                .tabItem {
                    Label("Playground",
                          systemImage: "dot.circle.and.hand.point.up.left.fill")
                }

            itemsView
                .tabItem {
                    Label("Score cards", systemImage: "list.number")
                }
        }
        .alert(
            viewModel.alert?.rawValue ?? "",
            isPresented: Binding(
                get: { viewModel.alert != nil },
                set: { _ in viewModel.alert = nil }
            )
        ) {
            Button("Retry") {
                viewModel.reset(
                    computerStarts: viewModel.alert == .youLoose
                )
                viewModel.alert = nil
            }
        }
    }

    // MARK: - Playground

    private var playgroundView: some View {
        GeometryReader { geo in
            let size = (geo.size.width - 32 - 20) / 3

            VStack(spacing: 32) {
                Spacer()

                titleView

                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: 10),
                        count: 3
                    ),
                    spacing: 10
                ) {
                    ForEach(0..<9, id: \.self) { index in
                        square(at: index, size: size)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }

    private func square(at index: Int, size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1),
                        radius: 10,
                        x: 1,
                        y: 1)

            marker(at: index)
        }
        .frame(width: size, height: size)
        .onTapGesture {
            viewModel.tap(square: index)
        }
    }

    @ViewBuilder
    private func marker(at index: Int) -> some View {
        switch markerType(at: index) {
        case .player:
            AnimatedXMarker()
        case .computer:
            AnimatedOMarker()
        case .none:
            EmptyView()
        }
    }

    private enum MarkerType {
        case player
        case computer
        case none
    }

    private func markerType(at index: Int) -> MarkerType {
        if viewModel.humanMoves.contains(index) { return .player }
        if viewModel.computerMoves.contains(index) { return .computer }
        return .none
    }

    private var titleView: some View {
        ZStack(alignment: .bottom) {
            Text("Tic-Tac-Toe")
                .font(.largeTitle)
                .fontWeight(.bold)

            MarkerLine()
                .stroke(
                    Color.black,
                    style: StrokeStyle(
                        lineWidth: 7,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .frame(width: 200, height: 1)
        }
    }

    // MARK: - Score Cards (unchanged)

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    private var itemsView: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    Text(
                        item.timestamp,
                        format: Date.FormatStyle(
                            date: .numeric,
                            time: .standard
                        )
                    )
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            modelContext.insert(Item(timestamp: Date()))
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(modelContext.delete)
        }
    }
}


#Preview {
    TicTacToeView()
}
