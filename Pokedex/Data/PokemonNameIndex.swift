import Foundation
import OSLog

struct PokemonName: Decodable {
    let id: Int
    let name: String
    let koreanName: String
}

struct PokemonNameIndex {
    let names: [PokemonName]

    func ids(matching query: String) -> [Int] {
        let number = Int(query.hasPrefix("#") ? String(query.dropFirst()) : query)
        return names.filter {
            $0.id == number
                || $0.koreanName.contains(query)
                || $0.name.localizedCaseInsensitiveContains(query)
        }
        .map(\.id)
    }
}

extension PokemonNameIndex {
    static let bundled: PokemonNameIndex = {
        guard let url = Bundle.main.url(forResource: "pokemon-names", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let names = try? JSONDecoder().decode([PokemonName].self, from: data)
        else {
            Logger.list.error("이름 목록을 읽지 못했어요")
            return PokemonNameIndex(names: [])
        }
        return PokemonNameIndex(names: names)
    }()
}
