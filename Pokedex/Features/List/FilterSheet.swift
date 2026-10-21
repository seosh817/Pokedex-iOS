import SwiftUI

struct FilterSheet: View {
    @Environment(FavoritesStore.self) private var favorites
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var favorites = favorites
        NavigationStack {
            Form {
                Toggle("즐겨찾기만 보기", isOn: $favorites.showOnlyFavorites.animation())
            }
            .navigationTitle("보기 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    FilterSheet()
        .environment(FavoritesStore())
}
