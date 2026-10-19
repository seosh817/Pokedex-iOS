actor SummaryCache {
    private var storage: [Int: PokemonSummary] = [:]
    private(set) var loadCount = 0
    
    func summary(
        id: Int,
        load: @Sendable () async throws -> PokemonSummary
    ) async throws -> PokemonSummary {
        if let cached = storage[id] {
            return cached
        }
        loadCount += 1
        let summary = try await load()
        storage[id] = summary
        return summary
    }
}
