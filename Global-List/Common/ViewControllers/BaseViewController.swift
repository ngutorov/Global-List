//
//  BaseViewController.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import UIKit

class BaseViewController: UIViewController, AlertsPresentable {
    
    let reachability = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setReachability()
    }
    
    private func setReachability() {
        reachability?.whenUnreachable = { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(title: "Network Error", message: "Please check your Internet connection and try again.")
        }
        try? reachability?.startNotifier()
    }
}
