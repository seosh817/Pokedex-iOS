import Foundation

struct PokeAPIClient {
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/")!

    func fetchPokemon(id: Int) async throws -> Pokemon {
        try await get("pokemon/\(id)")
    }

    func fetchSpecies(id: Int) async throws -> PokemonSpecies {
        try await get("pokemon-species/\(id)")
    }

    private func get<T: Decodable>(_ path: String) async throws -> T {
        let url = baseURL.appending(path: path)
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
