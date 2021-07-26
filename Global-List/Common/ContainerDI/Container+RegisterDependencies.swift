//
//  Container+RegisterDependencies.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/10/21.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerDependencies() {
        registerCoordinators()
        registerViewControllers()
        registerViewModels()
        registerServices()
    }
}

// MARK: - Coordinators

extension Container {
    func registerCoordinators() {
        
        self.autoregister(AppCoordinator.self,
                          initializer: AppCoordinator.init)
        
        self.autoregister(CountriesListCoordinator.self,
                          initializer: CountriesListCoordinator.init)
        
        self.autoregister(CountriesDetailCoordinator.self,
                          initializer: CountriesDetailCoordinator.init)
    }
}

// MARK: - ViewControllers

extension Container {
    func registerViewControllers() {
        
        self.autoregister(CountriesListViewController.self,
                          initializer: CountriesListViewController.init)
        
        self.autoregister(CountriesDetailViewController.self,
                          initializer: CountriesDetailViewController.init)
    }
}

// MARK: - ViewModels

extension Container {
    func registerViewModels() {
        
        self.autoregister(CountriesListViewModelType.self,
                          initializer: CountriesListViewModel.init)
        
        self.autoregister(CountriesDetailViewModelType.self,
                          initializer: CountriesDetailViewModel.init)
    }
}

// MARK: - Services

extension Container {
    func registerServices() {
        
        self.autoregister(NetworkServiceProtocol.self,
                          initializer: NetworkService.init).inObjectScope(.container)
    }
}
