//
//  TicTacToeViewModel.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 04.02.2026.
//


import Foundation
import Combine

@MainActor
final class TicTacToeViewModel: ObservableObject {

    // MARK: - Published properties
    @Published var selectedTab: TabItemType = .playground {
        didSet {
            if selectedTab == .scorecards {
                lastSelectedUser = selectedUser
                selectedUser = nil
            }
            if selectedTab == .playground, lastSelectedUser != nil {
                guard users.contains(where: { $0.id == lastSelectedUser?.id }) else {
                    isPlayerSelectionPresented = true
                    return
                }
                selectedUser = lastSelectedUser
            }
        }
    }
    @Published var isAddUserPresented = false
    @Published var isPlayerSelectionPresented = false

    @Published var selectedUser: User?
    @Published var lastSelectedUser: User?

    @Published private(set) var users: [User] = []
    @Published private(set) var humanMoves: Set<Int> = []
    @Published private(set) var computerMoves: Set<Int> = []
    @Published private(set) var alert: AlertTitle?
    @Published private(set) var winLineType: PlaygroundView.WinLineType?
    @Published private(set) var gameResult: GameResult?

    private(set) var currentGameStartTime: Date?
    private(set) var currentGameDuration: Double?
    private(set) var gamesWonByHuman: Int = 0
    private(set) var drawGamesCount: Int = 0
    private(set) var totalGamesCount: Int = 0
    private(set) var gamesWonInARow: Int = 0

    // MARK: - Stored properties
    private let engine = TicTacToeEngine()
    private weak var dataManager: SwiftDataManager?

    // MARK: - Init
    init(_ appContainer: AppContainer) {
        self.dataManager = appContainer.swiftDataManager
        prepareUsers()
    }

    func selectUser(_ user: User?) {
        selectedUser = user
    }


    func clearAlert() {
        alert = nil
    }

    func showAlert(_ alert: AlertTitle?) {
        self.alert = alert
    }
    
    private func showAlertWithDelay(_ alert: AlertTitle, delay: Double = 1.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.alert = alert
        }
    }
}

private extension TicTacToeViewModel {
    func prepareUsers() {
        var users = dataManager?.fetchUsers()
        if users?.isEmpty == true || users == nil {
            users = Mocks.users
            Mocks.users.forEach {
                dataManager?.insert(user: $0)
            }
            dataManager?.save()
        }
        self.users = users ?? []
    }
}

// MARK: - TicTacToeEngine Engine methods
extension TicTacToeViewModel {
    func tap(square: Int) {
        guard !humanMoves.contains(square),
              !computerMoves.contains(square)
        else {
            alert = .squareIsAlreadySelected
            return
        }
        humanMoves.insert(square)
        if currentGameStartTime == nil {
            updateStartTime()
        }
        resolveGame(afterHumanMove: true)
    }

    private func resolveGame(afterHumanMove: Bool) {
        let resolvedResult = engine.gameResult(human: humanMoves, computer: computerMoves)
        switch resolvedResult.result {
        case .win(.human):
            showAlertWithDelay(.youWin)
            updateGameStats(.win(.human))
            winLineType = resolvedResult.winLine
        case .win(.computer):
            showAlertWithDelay(.youLoose)
            updateGameStats(.win(.computer))
            winLineType = resolvedResult.winLine
        case .draw:
            showAlertWithDelay(.draw)
            updateGameStats(.draw)
        case .ongoing:
            guard afterHumanMove,
                  let move = engine.computerMove(
                    human: humanMoves,
                    computer: computerMoves
                  )
            else { return }
            computerMoves.insert(move)
            resolveGame(afterHumanMove: false)
        }
    }

    private func updateStartTime() {
        currentGameStartTime = Date()
    }

    private func updateGameStats(_ gameResult: GameResult) {
        self.gameResult = gameResult
        updateGameDuration()
        totalGamesCount += 1
        switch gameResult {
        case .win(let player):
            switch player {
            case .human:
                gamesWonByHuman += 1
                gamesWonInARow += 1
            case .computer:
                gamesWonInARow = 0
                break
            }
        case .draw:
            drawGamesCount += 1
        default:
            break
        }
    }

    private func updateGameDuration() {
        let gameDuration = computedGameDuration(Date())
        currentGameDuration = gameDuration
        currentGameStartTime = nil
    }

    private func computedGameDuration(_ currentTime: Date) -> Double {
        guard let currentGameStartTime else {
            assertionFailure("Current game start time is nil")
            return 0.0
        }
        let seconds = abs(currentTime.timeIntervalSince(currentGameStartTime))
        return seconds
    }

    func reset(computerStarts: Bool = false) {
        humanMoves = []
        computerMoves = []
        winLineType = nil
        gameResult = nil
        if computerStarts {
            computerMoves.insert(Int.random(in: 0...8))
            updateStartTime()
        }
    }
}

// MARK: - SwiftDataManager methods
extension TicTacToeViewModel {
    func load() {
        users = dataManager?.fetchUsers() ?? []
    }

    @discardableResult
    func addUser(name: String, image: String) -> User {
        let user = User(name, image)
        dataManager?.insert(user: user)
        load()
        return user
    }

    func deleteUser(at offsets: IndexSet) {
        offsets
            .map { users[$0] }
            .forEach { dataManager?.delete(user: $0) }
        load()
    }
}
