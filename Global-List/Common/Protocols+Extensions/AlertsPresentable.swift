//
//  AlertsPresentable.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import UIKit

protocol AlertsPresentable: AnyObject {}

extension AlertsPresentable where Self: UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
