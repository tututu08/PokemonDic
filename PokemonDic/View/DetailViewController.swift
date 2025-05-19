//
//  DetailViewController.swift
//  PokemonDic
//
//  Created by 강성훈 on 5/19/25.
//
import UIKit
import SnapKit
import RxSwift
import Kingfisher

final class DetailViewController: UIViewController {
    
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    private let pokemonId: Int
    
    private let infoCardView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let heightLabel = UILabel()
    private let weightLabel = UILabel()
    private let typeLabel = UILabel()
    
    init(pokemonId: Int) {
        self.pokemonId = pokemonId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bind()
        viewModel.fetchDetail(for: pokemonId)
    }
    
    private func setupUI() {
        view.backgroundColor = .mainRed
        
        infoCardView.backgroundColor = .darkRed
        infoCardView.layer.cornerRadius = 20
        
        imageView.contentMode = .scaleAspectFit
        
        [infoCardView, imageView].forEach { view.addSubview($0) }
        [nameLabel, typeLabel, heightLabel, weightLabel].forEach {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 16)
            infoCardView.addSubview($0)
        }
        
        nameLabel.font = .boldSystemFont(ofSize: 30)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(180)
        }
        
        infoCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(400)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
           viewModel.pokemonDetail
               .observe(on: MainScheduler.instance)
               .subscribe(onNext: { [weak self] detail in
                   guard let self = self else { return }
                   guard let detail = detail else { return }
                   let nameKo = PokemonTranslator.getKoreanName(for: detail.name)
                   let typeKo = PokemonTypeName(rawValue: detail.types.first?.type.name ?? "")?.displayName ?? detail.types.first?.type.name ?? "알수없음"
                   
                   nameLabel.text = "No.\(detail.id)  \(nameKo)"
                   typeLabel.text = "타입: \(typeKo)"
                   heightLabel.text = "키: \(Double(detail.height) / 10)m"
                   weightLabel.text = "몸무게: \(Double(detail.weight) / 10)kg"
                   
                   let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(detail.id).png")
                   imageView.kf.setImage(with: imageUrl)
               })
               .disposed(by: disposeBag)
       }
}

