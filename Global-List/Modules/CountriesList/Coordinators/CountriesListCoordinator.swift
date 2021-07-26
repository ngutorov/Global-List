//
//  CountriesListCoordinator.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import UIKit
import RxSwift

final class CountriesListCoordinator: MainCoordinator {
    
    // MARK: - Properties
    
    private let viewModel: CountriesListViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(viewModel: CountriesListViewModelType) {
        self.viewModel = viewModel
        super.init()
        
        setupBindings()
    }
    
    // MARK: - Start
    
    override func start() {
        let viewController = CountriesListViewController(self.viewModel)
        self.navigationController.setViewControllers([viewController], animated: true)
    }
    
    // MARK: - Setup Bindings
    
    private func setupBindings() {
        
        // Navigate to Detail Screen
        viewModel.outputs.selectedSubject
            .subscribe(onNext: { [weak self] country in
                if let country = country {
                    self?.navigateToDetail(for: country)
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    func navigateToDetail(for country: CountryModel) {
        let detailCoordinator = AppDelegate.container.resolve(CountriesDetailCoordinator.self)!
        
        // Setup Detail Coordinator
        detailCoordinator.navigationController = self.navigationController
        detailCoordinator.parentCoordinator = self
        detailCoordinator.detailSubject.accept(country.name)
        
        let sharedSubject = detailCoordinator.detailSubject.share()
        sharedSubject
            .subscribe(onNext: { [weak self] _ in
                self?.dismissDetailCoordinator()
            }).disposed(by: disposeBag)
        
        self.start(coordinator: detailCoordinator)
    }
    
    // Dismiss Detail
    private func dismissDetailCoordinator() {
        self.navigationController.popToRootViewController(animated: true)
        self.removeAll()
    }
}
