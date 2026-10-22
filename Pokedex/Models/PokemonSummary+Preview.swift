import PokeAPI

extension PokemonSummary {
    static let bulbasaur = PokemonSummary(id: 1, name: "bulbasaur", koreanName: "이상해씨", types: ["grass", "poison"])
    static let charmander = PokemonSummary(id: 4, name: "charmander", koreanName: "파이리", types: ["fire"])
    static let pikachu = PokemonSummary(id: 25, name: "pikachu", koreanName: "피카츄", types: ["electric"])
    
    static let samples: [PokemonSummary] = [
        bulbasaur,
        PokemonSummary(id: 2, name: "ivysaur", koreanName: "이상해풀", types: ["grass", "poison"]),
        PokemonSummary(id: 3, name: "venusaur", koreanName: "이상해꽃", types: ["grass", "poison"]),
        charmander,
        PokemonSummary(id: 5, name: "charmeleon", koreanName: "리자드", types: ["fire"]),
        PokemonSummary(id: 6, name: "charizard", koreanName: "리자몽", types: ["fire", "flying"]),
        PokemonSummary(id: 7, name: "squirtle", koreanName: "꼬부기", types: ["water"]),
        PokemonSummary(id: 8, name: "wartortle", koreanName: "어니부기", types: ["water"]),
        PokemonSummary(id: 9, name: "blastoise", koreanName: "거북왕", types: ["water"]),
        pikachu,
    ]
}
