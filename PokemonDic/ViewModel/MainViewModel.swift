//
//  MainViewModel.swift
//  PokemonDic
//
//  Created by 강성훈 on 5/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    
    private let disposeBag = DisposeBag()
    
    let pokemonList = BehaviorRelay<[Pokemon]>(value: [])
    
    private var offset = 0
    private let limit = 20
    private var isLoading = false

    func fetchPokemonList() {
        guard !isLoading else { return }
               isLoading = true
        
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .map { (response: PokemonListResponse) in
                response.results
            }
            .subscribe(onSuccess: { [weak self] newPokemon in
                let current = self?.pokemonList.value ?? []
                self?.pokemonList.accept(current + newPokemon)
                self?.offset += self?.limit ?? 0
                self?.isLoading = false
            }, onFailure: { error in
                    print("리스트 가져오기 실패")
                self.isLoading = false
            })
            .disposed(by: disposeBag)
    }
}
