//
//  MainCoordinator.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/10/21.
//

import UIKit

// MARK: - Main Coordinator (Abstract Base Coordinator)

class MainCoordinator: Coordinator {
    
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    var parentCoordinator: Coordinator?
    
    func start() {
        fatalError("start() method must be overriden")
    }
    
    func start(coordinator: Coordinator) {
        childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func remove(coordinator: Coordinator) {
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
        }
    }
    
    func removeAll() {
        childCoordinators.forEach { $0.removeAll() }
        childCoordinators.removeAll()
    }
}
