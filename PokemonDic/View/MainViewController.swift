import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pokemonBall"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainRed
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bind()
        viewModel.fetchPokemonList()
    }
        
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 12
        let itemsPerRow: CGFloat = 3
        let totalSpacing = padding * (itemsPerRow + 1)
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / itemsPerRow

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 8)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return layout
    }

    private func setupUI() {
        view.backgroundColor = .mainRed
        view.addSubview(headerImageView)
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        headerImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func bind() {
        viewModel.pokemonList
            .bind(to: collectionView.rx.items(
                cellIdentifier: PokemonCell.identifier,
                cellType: PokemonCell.self)
            ) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(Pokemon.self)
            .subscribe(onNext: { [weak self] pokemon in
                guard let id = pokemon.id else { return }
                let detailVC = DetailViewController(pokemonId: id)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)

        
        collectionView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }

                let contentHeight = self.collectionView.contentSize.height
                let scrollViewHeight = self.collectionView.frame.size.height
                let scrollOffset = offset.y

                if scrollOffset > contentHeight - scrollViewHeight - 100 {
                    self.viewModel.fetchPokemonList()
                }
            })
            .disposed(by: disposeBag)
    }
}
