//
//  CountriesDetailCoordinator.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/20/21.
//

import RxSwift
import RxCocoa

final class CountriesDetailCoordinator: MainCoordinator {
    
    // MARK: - Properties
    
    private let viewModel: CountriesDetailViewModelType
    private let disposeBag = DisposeBag()
    
    var detailSubject: BehaviorRelay<String?> = .init(value: nil)
    
    // MARK: - Init
    
    init(viewModel: CountriesDetailViewModelType) {
        self.viewModel = viewModel
        super.init()
        
        setupBindings()
    }
    
    // MARK: - Start
    
    override func start() {
        let viewController = CountriesDetailViewController(self.viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Setup Bindings
    
    private func setupBindings() {
        
        self.detailSubject
            .bind(to: viewModel.loadDetailSubject)
            .disposed(by: disposeBag)
        
        // Remove Coordinator when dismissed
        viewModel.dismissSubject.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.parentCoordinator?.remove(coordinator: self)
        }).disposed(by: disposeBag)
    }
}
