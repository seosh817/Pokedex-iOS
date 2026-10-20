import SwiftUI

struct FavoriteButton: View {
    @State private var isOn = false
    
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Image(systemName: isOn ? "star.fill" : "star")
                .font(.title2)
                .foregroundStyle(isOn ? .yellow : .secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isOn ? "즐겨찾기 해제" : "즐겨찾기에 추가")
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    FavoriteButton()
        .padding()
}
