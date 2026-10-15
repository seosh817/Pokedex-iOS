import Foundation

struct PokeAPIClient {
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/")!
    
    func fetchPokemon(id: Int) async throws -> Pokemon {
        let url = baseURL.appending(path: "pokemon/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }
}
