//
//  PokemonCell.swift
//  PokemonDic
//
//  Created by 강성훈 on 5/19/25.
//
import UIKit
import Kingfisher

class PokemonCell: UICollectionViewCell {
    static let identifier = "PokemonCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .cellBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.darkRed.cgColor

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.width - 20)

    }
    func configure(with pokemon: Pokemon) {
        guard let id = pokemon.id else { return }
        let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
        imageView.kf.setImage(with: imageURL)
    }
}
