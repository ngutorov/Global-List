//
//  AppCoordinator.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/10/21.
//

import UIKit

final class AppCoordinator: MainCoordinator {
    
    var rootViewController: UIViewController?
    
    // MARK: - Start
    
    override func start() {
        
        // Inject Main Coordinator
        let coordinator = AppDelegate.container.resolve(CountriesListCoordinator.self)!
        self.start(coordinator: coordinator)
        
        rootViewController = coordinator.navigationController
    }
}
