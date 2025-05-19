import Foundation

struct PokemonListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results : [Pokemon]
    
}

struct Pokemon: Decodable {
    let name: String
    let url: String
    
    var id: Int? {
        return Int(url.split(separator: "/").last ?? "")
    }
}

