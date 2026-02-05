//
//  AddUserView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//


import SwiftUI

struct AddUserView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedImageName: String?
    @State private var name: String = ""
    @FocusState private var isFocused: Bool

    private let images = Mocks.userImages

    var onAddHandler: ((String, String) -> Void)? = nil

    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section("User name") {
                    TextField("Enter name here", text: $name)
                        .focused($isFocused)
                }
                Section("User image") {
                    LazyVGrid(
                        columns: Array(
                            repeating: .init(.flexible(), spacing: 10),
                            count: UIDevice.current.userInterfaceIdiom == .phone
                            ? 3 : 5),
                        content: {
                        ForEach(images, id: \.self) { image in
                            UserImageView(Binding(get: { selectedImageName == image }, set: { _ in }), imageName: image)
                                .animation(.easeInOut, value: selectedImageName)
                                .onTapGesture {
                                    if selectedImageName == image {
                                        selectedImageName = nil
                                    } else {
                                        selectedImageName = image
                                    }
                                }
                        }
                    })
                    .padding(16)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard let selectedImageName else { return }
                        onAddHandler?(name.trimmingCharacters(in: .whitespacesAndNewlines), selectedImageName)
                        dismiss()
                    }
                    .disabled(
                        name.trimmingCharacters(in: .whitespaces).isEmpty
                        || selectedImageName == nil
                    )
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AddUserView()
}
