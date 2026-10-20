import SwiftUI

struct FavoriteButton: View {
    @Binding var isOn: Bool
    
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
    @Previewable @State var isOn: Bool = false
    FavoriteButton(isOn: $isOn)
        .padding()
}
