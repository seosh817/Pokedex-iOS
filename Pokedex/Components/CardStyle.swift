import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                Color(.secondarySystemGroupedBackground)
                    .shadow(.drop(color: .black.opacity(0.1), radius: 4, y:2)),
                in: .rect(cornerRadius: 16)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
