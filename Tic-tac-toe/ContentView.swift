//
//  ContentView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//

import SwiftUI
import SwiftData

enum AlertTitle: LocalizedStringKey {
    case squareIsAlreadySelected = "This square is already selected"
    case draw = "It's a draw"
    case youWin = "You win! Well done!"
    case youLoose = "You loose, i will be the first now :)"
    case unknown = "Unknown error"
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var userSelectedSquares = Set<Int>()
    @State private var computedSelectionSquares = Set<Int>()
    @State private var isActionsDisabled = false

    @State private var isAlertVisible = false
    @State private var alertTitle: AlertTitle = .unknown

    private let allSquares: Set<Int> = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    private let successCombinations: Set<Set<Int>> = [
        [0, 1, 2], // first horizontal row
        [3, 4, 5], // second horizontal row
        [6, 7, 8], // third horizontal row
        [0, 4, 8], // first diagonal row
        [2, 4, 6], // second diagonal row
        [0, 3, 6], // first vertical row
        [1, 4, 7], // second vertical row
        [2, 5, 8] // third vertical row
    ]

    var body: some View {
        TabView {
            playgroundView
                .tabItem {
                    Label("Playground", systemImage: "dot.circle.and.hand.point.up.left.fill")
                }
            itemsView
                .tabItem {
                    Label("Score cards", systemImage: "list.number")
                }
        }
        .alert(alertTitle.rawValue, isPresented: $isAlertVisible, actions: {
            Button("Retry") {
                switch alertTitle {
                case .squareIsAlreadySelected:
                    break
                case .draw, .youWin, .unknown:
                    userSelectedSquares = []
                    computedSelectionSquares = []
                case .youLoose:
                    userSelectedSquares = []
                    computedSelectionSquares = []
                    computedSelectionSquares.insert(allSquares.randomElement() ?? 0)
                }
                isAlertVisible = false
            }
        })
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    private var itemsView: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
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

    private var playgroundView: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let size = (side - 32 - 20) / 3
            VStack(spacing: 32) {
                if side != geo.size.height {
                    ZStack(alignment: .bottom) {
                        Text("Tic-tac-toe")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        MarkerLine()
                            .stroke(
                                Color.black,
                                style: StrokeStyle(
                                    lineWidth: 7,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                            .frame(width: 200, height: 1, alignment: .bottom)
                    }
                }
                ZStack {
                    LazyVGrid(
                        columns: Array(repeating: .init(.fixed(size), spacing: 10, alignment: .center), count: 3),
                        alignment: .center,
                        spacing: 10,
                        content: {
                            ForEach(Array(allSquares).enumerated(), id: \.offset) { index, element in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.white)
                                        .shadow(color: .black.opacity(0.1), radius: 10, x: 1, y: 1)
                                    ZStack {
                                        switch computeMarkerType(from: index) {
                                        case .player:
                                            AnimatedXMarker(size: size / 1.5)
                                        case .computer:
                                            AnimatedOMarker(size: size / 1.5)
                                        default:
                                            EmptyView()
                                        }
                                    }
                                }
                                .frame(width: size, height: size)
                                .onTapGesture {
                                    guard !isActionsDisabled else { return }
                                    print("---> Start new session <---")
                                    isActionsDisabled = true
                                    defer {
                                        isActionsDisabled = false
                                        print("---> End new session <---")
                                    }
                                    if !isComputedSelectionSquare(at: index) && !isUserSelectedSquare(at: index) {
                                        userSelectedSquares.insert(index)
                                    } else {
                                        alertTitle = .squareIsAlreadySelected
                                        isAlertVisible = true
                                        return
                                    }
                                    print("current user selection is \(userSelectedSquares)")
                                    print("current computed selection is \(computedSelectionSquares)")
                                    let userPossibleCombinations = successCombinations.filter {
                                        let userIntersection = $0.intersection(userSelectedSquares)
                                        guard userIntersection.count == 2 else { return false }
                                        let computedIntersection = $0.intersection(computedSelectionSquares)
                                        guard computedIntersection.isEmpty else { return false }
                                        return true
                                    }

                                    print("userPossibleCombinations \(userPossibleCombinations)")
                                    var computedSelectionPossibleCombinations: Set<Set<Int>> = successCombinations.filter {
                                        let userIntersection = $0.intersection(computedSelectionSquares)
                                        guard userIntersection.count == 2 else { return false }
                                        let computedIntersection = $0.intersection(userSelectedSquares)
                                        guard computedIntersection.isEmpty else { return false }
                                        return true
                                    }
                                    if let _ = userPossibleCombinations.first,
                                       computedSelectionPossibleCombinations.count == 0 {
                                        computedSelectionPossibleCombinations = userPossibleCombinations
                                    }
                                    print("computed combinations are not empty, check is your win")
                                    if successCombinations.contains(where: { $0.isSubset(of: userSelectedSquares) || $0.isSuperset(of: userSelectedSquares) }) && userSelectedSquares.count >= 3 {
                                        alertTitle = .youWin
                                        isAlertVisible = true
                                        return
                                    }
                                    print("computedSelectionPossibleCombinations \(computedSelectionPossibleCombinations)")
                                    print("check is computer possible combinations is empty")
                                    if computedSelectionPossibleCombinations.isEmpty {
                                        let freeSquares = allSquares.subtracting(userSelectedSquares.union(computedSelectionSquares))
                                        if let first = freeSquares.first {
                                            print("insert computer value at free index \(first)")
                                            computedSelectionSquares.insert(first)
                                            print("check is computer wins")
                                            if successCombinations.contains(where: { $0.isSubset(of: computedSelectionSquares) || $0.isSuperset(of: computedSelectionSquares) }) && computedSelectionSquares.count >= 3 {
                                                alertTitle = .youLoose
                                                isAlertVisible = true
                                                return
                                            } else {
                                                let freeSquares = allSquares.subtracting(userSelectedSquares.union(computedSelectionSquares))
                                                if freeSquares.count == 0 {
                                                    print("it is empty, it is draw ?")
                                                    alertTitle = .draw
                                                    isAlertVisible = true
                                                    return
                                                }
                                            }
                                        } else {
                                            print("it is empty, it is draw ?")
                                            alertTitle = .draw
                                            isAlertVisible = true
                                            return
                                        }
                                    } else {
                                        if computedSelectionPossibleCombinations.count == 1,
                                                  let lastPossibleChance = computedSelectionPossibleCombinations.first,
                                                  let lastPossibleIndex = lastPossibleChance.first(where: { !userSelectedSquares.contains($0) && !computedSelectionSquares.contains($0) })
                                        {
                                            print("computed set is last chance \(lastPossibleChance)")
                                            print("insert computer value at last possible chance index \(lastPossibleIndex)")
                                            computedSelectionSquares.insert(lastPossibleIndex)
                                            print("check is computer wins")
                                            if successCombinations.contains(where: { $0.isSubset(of: computedSelectionSquares) || $0.isSuperset(of: computedSelectionSquares) }) && computedSelectionSquares.count >= 3 {
                                                alertTitle = .youLoose
                                                isAlertVisible = true
                                                return
                                            } else {
                                                let freeSquares = allSquares.subtracting(userSelectedSquares.union(computedSelectionSquares))
                                                if freeSquares.count == 0 {
                                                    print("it is empty, it is draw ?")
                                                    alertTitle = .draw
                                                    isAlertVisible = true
                                                    return
                                                }
                                            }
                                        } else if computedSelectionPossibleCombinations.count == 2,
                                                  let first = computedSelectionPossibleCombinations.first {
                                            let intersection = first.subtracting(computedSelectionSquares)
                                            if let possibleIndexToInsert = intersection.first(where: { !userSelectedSquares.contains($0) }) {
                                                print("intersection found and index is \(possibleIndexToInsert)")
                                                computedSelectionSquares.insert(possibleIndexToInsert)
                                                print("check is computer wins")
                                                if successCombinations.contains(where: { $0.isSubset(of: computedSelectionSquares) || $0.isSuperset(of: computedSelectionSquares) }) && computedSelectionSquares.count >= 3 {
                                                    alertTitle = .youLoose
                                                    isAlertVisible = true
                                                    return
                                                }
                                            }
                                        } else if let firstCombination = computedSelectionPossibleCombinations.first(where: { (computedSelectionSquares.isSubset(of: $0) || computedSelectionSquares.isSuperset(of: $0)) }),
                                                  let firstValue = firstCombination.filter({ !computedSelectionSquares.contains($0) }).first {
                                            print("computed set is \(firstCombination)")
                                            print("insert computer value at index \(firstValue)")
                                            computedSelectionSquares.insert(firstValue)
                                            print("check is computer wins")
                                            if successCombinations.contains(where: { $0.isSubset(of: computedSelectionSquares) || $0.isSuperset(of: computedSelectionSquares) }) && computedSelectionSquares.count >= 3 {
                                                alertTitle = .youLoose
                                                isAlertVisible = true
                                                return
                                            }
                                        } else {
                                            print("it is empty, it is unknown!")
                                            alertTitle = .unknown
                                            isAlertVisible = true
                                        }
                                    }


                                }
                            }
                        }
                    )
                    if isActionsDisabled {
                        ProgressView()
                            .tint(.black)
                    }
                }
                .padding(.bottom, 32)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }

    private func isUserSelectedSquare(at index: Int) -> Bool {
        userSelectedSquares.contains(index)
    }

    private func isComputedSelectionSquare(at index: Int) -> Bool {
        computedSelectionSquares.contains(index)
    }

    private enum MarkerType {
        case player
        case computer
        case none
    }

    private func computeMarkerType(from index: Int) -> MarkerType {
        if isUserSelectedSquare(at: index) {
            return .player
        } else if isComputedSelectionSquare(at: index) {
            return .computer
        } else {
            return .none
        }
    }

    private func computeTextColor(from index: Int) -> Color {
        if isUserSelectedSquare(at: index) {
            return .blue
        } else if isComputedSelectionSquare(at: index) {
            return .red
        } else {
            return .gray.opacity(0.2)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
