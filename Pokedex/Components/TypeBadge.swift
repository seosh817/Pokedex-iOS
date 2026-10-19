import SwiftUI

struct TypeBadge: View {
    let type: String
    
    var body: some View {
        Text(koreanName)
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color, in: .capsule)
    }
    
    private var koreanName: String {
        switch type {
        case "normal": "노말"
        case "fire": "불꽃"
        case "water": "물"
        case "grass": "풀"
        case "electric": "전기"
        case "ice": "얼음"
        case "fighting": "격투"
        case "poison": "독"
        case "ground": "땅"
        case "flying": "비행"
        case "psychic": "에스퍼"
        case "bug": "벌레"
        case "rock": "바위"
        case "ghost": "고스트"
        case "dragon": "드래곤"
        case "dark": "악"
        case "steel": "강철"
        case "fairy": "페어리"
        default: type
        }
    }
    
    private var color: Color {
        switch type {
        case "fire": .orange
        case "water": .blue
        case "grass": .green
        case "electric": Color(red: 0.9, green: 0.7, blue: 0)
        case "ice": .cyan
        case "fighting": .red
        case "poison": .purple
        case "ground": .brown
        case "flying": .indigo
        case "psychic": .pink
        case "bug": .mint
        case "rock": Color(red: 0.6, green: 0.5, blue: 0.3)
        case "ghost": Color(red: 0.4, green: 0.3, blue: 0.6)
        case "dragon": Color(red: 0.4, green: 0.2, blue: 0.9)
        case "dark": Color(red: 0.3, green: 0.25, blue: 0.2)
        case "steel": Color(red: 0.5, green: 0.55, blue: 0.6)
        case "fairy": Color(red: 0.9, green: 0.5, blue: 0.7)
        default: .gray
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HStack {
        TypeBadge(type: "grass")
        TypeBadge(type: "poison")
        TypeBadge(type: "electric")
    }
    .padding()
}
