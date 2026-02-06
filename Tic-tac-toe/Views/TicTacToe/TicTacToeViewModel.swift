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
    @Published var selectedTab: TabItemType = .playground
    @Published var isAddUserPresented = false
    @Published var isPlayerSelectionPresented = false

    @Published var selectedUser: User?
    @Published var selectedUserScorecard: User?

    @Published private(set) var users: [User] = []
    @Published private(set) var humanMoves: Set<Int> = []
    @Published private(set) var computerMoves: Set<Int> = []
    @Published private(set) var alert: AlertTitle?
    @Published private(set) var winLineType: PlaygroundView.WinLineType?
    @Published private(set) var gameResult: GameResult?

    @Published private(set) var currentGameStartTime: Date?
    @Published private(set) var currentGameDuration: Double?
    @Published private(set) var gamesWonInARow: Int = 0

    // MARK: - Stored properties
    private let engine = TicTacToeEngine()
    private let userDefaultsManager = UserDefaultsManager.shared
    private let dataManager: SwiftDataManagerProtocol
    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    init(_ appContainer: AppContainer) {
        self.dataManager = appContainer.swiftDataManager
        self.networkManager = appContainer.networkManager
    }

    func sendUserData() async throws {
        try await networkManager.sendData(users)
    }

    func prepareUsers() async {
        guard users.isEmpty else { return }
        var users = await dataManager.fetchUsers()
        if users.isEmpty {
            users = Mocks.users
            Mocks.users.forEach {
                dataManager.insert(user: $0)
            }
            dataManager.save()
        }
        self.users = users
        if let lastSelectedUserId = userDefaultsManager.lastSelectedPlayerId,
           let lastSelectedUser = users.first(where: { $0.id == UUID(uuidString: lastSelectedUserId) }) {
            selectedUser = lastSelectedUser
        }
        if selectedUser == nil {
            isPlayerSelectionPresented = true
        }
    }

    func selectUser(_ user: User?) {
        gamesWonInARow = 0
        selectedUser = user
        userDefaultsManager.lastSelectedPlayerId = selectedUser?.id.uuidString
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
            showAlertWithDelay(.youLose)
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
        selectedUser?.totalGamesCount += 1
        switch gameResult {
        case .win(let player):
            switch player {
            case .human:
                selectedUser?.gamesWonByHuman += 1
                gamesWonInARow += 1
                if (selectedUser?.gamesWonInARow ?? 0) < gamesWonInARow {
                    selectedUser?.gamesWonInARow = gamesWonInARow
                }

            case .computer:
                gamesWonInARow = 0
                break
            }
        case .draw:
            selectedUser?.drawGamesCount += 1
        default:
            break
        }
    }

    private func updateGameDuration() {
        let gameDuration = computedGameDuration(Date())
        currentGameDuration = gameDuration
        selectedUser?.totalInGameTime += gameDuration
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
    func load() async {
        users = await dataManager.fetchUsers()
    }

    @discardableResult
    func addUser(name: String, image: String) async -> User {
        let user = User(name, image)
        dataManager.insert(user: user)
        await load()
        return user
    }

    func deleteUser(at offsets: IndexSet) async {
        offsets
            .map { users[$0] }
            .forEach { dataManager.delete(user: $0) }
        await load()
    }
}
