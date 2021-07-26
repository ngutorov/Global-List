//
//  CoordinatorProtocol.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/10/21.
//

import UIKit

// MARK: - Coordinator Protocol

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func remove(coordinator: Coordinator)
    func removeAll()
}
