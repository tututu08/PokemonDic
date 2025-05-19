//
//  NetworkManager.swift
//  PokemonDic
//
//  Created by 강성훈 on 5/18/25.
//

import Foundation
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single<T>.create { single in
            let task = URLSession.shared.dataTask(with: url) {
                data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let data = data else {
                    single(.failure(NSError(domain: "no data", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    single(.success(decoded))
                } catch {
                    single(.failure(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

