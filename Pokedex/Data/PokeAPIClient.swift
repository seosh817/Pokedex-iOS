import Foundation

struct PokeAPIClient {
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
    private let session: URLSession
    private let summaryCache: SummaryCache
    
    init(session: URLSession = .shared, summaryCache: SummaryCache = SummaryCache()) {
        self.session = session
        self.summaryCache = summaryCache
    }

    func fetchPokemon(id: Int) async throws -> Pokemon {
        try await get("pokemon/\(id)")
    }

    func fetchSpecies(id: Int) async throws -> PokemonSpecies {
        try await get("pokemon-species/\(id)")
    }

    func fetchSummary(id: Int) async throws -> PokemonSummary {
        try await summaryCache.summary(id: id) {
            try await loadSummary(id: id)
        }
    }
    
    private func loadSummary(id: Int) async throws -> PokemonSummary {
        async let pokemon = fetchPokemon(id: id)
        async let species = fetchSpecies(id: id)
        let (p, s) = try await (pokemon, species)
        return PokemonSummary(
            id: p.id,
            name: p.name,
            koreanName: s.koreanName ?? p.name,
            types: p.types.map(\.type.name)
        )
    }

    func fetchSummaries(ids: [Int]) async throws -> [PokemonSummary] {
        try await withThrowingTaskGroup(of: PokemonSummary.self) {
            group in
            for id in ids {
                group.addTask { try await fetchSummary(id: id) }
            }
            var results: [PokemonSummary] = []
            for try await result in group {
                results.append(result)
            }
            return results.sorted { $0.id < $1.id }
        }
    }

    private func get<T: Decodable & Sendable>(_ path: String) async throws -> T {
        let url = baseURL.appending(path: path)
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }
        return try await Self.decode(data)
    }
    
    @concurrent
    private static func decode<T: Decodable & Sendable>(_ data: Data) async throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
