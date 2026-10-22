actor SummaryCache {
    private var tasks: [Int: Task<PokemonSummary, Error>] = [:]
    private(set) var loadCount = 0
    
    func summary(
        id: Int,
        load: @escaping @Sendable () async throws -> PokemonSummary
    ) async throws -> PokemonSummary {
        if let task = tasks[id] {
            return try await task.value
        }
        loadCount += 1
        let task = Task { try await load() }
        tasks[id] = task
        do {
            return try await task.value
        } catch {
            tasks[id] = nil
            throw error
        }
    }
}
