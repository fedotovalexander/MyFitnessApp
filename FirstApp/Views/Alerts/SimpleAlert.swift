//
//  SimpleAlert.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 23.01.2022.
//

import UIKit

extension UIViewController {
    
    func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
}



