//
//  Pokemon.swift
//  PokemonDic
//
//  Created by 강성훈 on 5/18/25.
//

import Foundation

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeList]
}

struct PokemonTypeList: Decodable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Decodable {
    let name: String
    let url: String
}
