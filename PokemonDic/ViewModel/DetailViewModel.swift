//
//  DetailViewModel.swift
//  PokemonDic
//
//  Created by 강성훈 on 5/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel {

    private let disposeBag = DisposeBag()

    let pokemonDetail = BehaviorRelay<PokemonDetail?>(value: nil)

    func fetchDetail(for id: Int) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/") else { return }

        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (detail: PokemonDetail) in
                self?.pokemonDetail.accept(detail)
            }, onFailure: { error in
                print("상세 조회 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
