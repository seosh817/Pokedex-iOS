import PokeAPI
import SwiftUI

struct StatsCard: View {
    let stats: [PokemonDetail.Stat]
    @State private var isShown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("기본 능력치")
                    .font(.headline)
                Spacer()
                Text("합계 \(stats.map(\.value).reduce(0, +))")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
                ForEach(stats) { stat in
                    GridRow {
                        Text(stat.name)
                            .foregroundStyle(.secondary)
                        Text("\(stat.value)")
                            .monospacedDigit()
                            .bold()
                            .gridColumnAlignment(.trailing)
                        bar(for: stat.value)
                    }
                    .font(.subheadline)
                }
            }
        }
        .padding()
        .background(.quaternary.opacity(0.5), in: .rect(cornerRadius: 16))
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isShown = true
            }
        }
    }

    private func bar(for value: Int) -> some View {
        Capsule()
            .fill(Color.secondary.opacity(0.15))
            .frame(height: 10)
            .overlay(alignment: .leading) {
                GeometryReader { proxy in
                    Capsule()
                        .fill(color(for: value).gradient)
                        .frame(width: proxy.size.width * (isShown ? Double(value) / 255 : 0))
                }
            }
    }

    private func color(for value: Int) -> Color {
        switch value {
        case ..<60: .orange
        case ..<90: .yellow
        case ..<120: .green
        default: .teal
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    StatsCard(stats: [
        .init(name: "HP", value: 35),
        .init(name: "공격", value: 55),
        .init(name: "방어", value: 40),
        .init(name: "특수공격", value: 50),
        .init(name: "특수방어", value: 50),
        .init(name: "스피드", value: 90),
    ])
    .padding()
}
