import Foundation

nonisolated struct Pokemon: Decodable {
    let id: Int
    let name: String
    let height: Int // 데시미터 (4 -> 0.4m)
    let weight: Int // 헥토그램 (60 -> 6.0kg)
    let types: [TypeSlot]
    
    struct TypeSlot: Decodable {
        let slot: Int
        let type: NamedResource
    }
}

nonisolated struct NamedResource: Decodable {
    let name: String
    let url: URL
}
