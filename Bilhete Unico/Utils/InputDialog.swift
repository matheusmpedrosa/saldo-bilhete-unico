//
//  InputDialog.swift
//  Bilhete Unico
//
//  Created by Matheus Pedrosa on 8/4/19.
//  Copyright © 2019 M2P. All rights reserved.
//

import UIKit

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlertWithOptions(title: String?, message: String?, style: UIAlertController.Style, options: String..., completion: @escaping (Float64) -> Void) {
        let alertController =  UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (index, option) in options.enumerated() {
            
            let action = UIAlertAction(title: option, style: .default, handler: { (action) in
                switch index {
                case 0:
                    completion(50.0)
                    print("index 0")
                case 1:
                    completion(100.0)
                    print("index 1")
                default:
                    fatalError("Algo deu errado no alerta")
                }
                
            })
            
            let image = UIImage(named: options[index].lowercased())
            let imageView = UIImageView()
            imageView.image = image
            imageView.frame = CGRect(x: 25, y: 18, width: 24, height: 24)
            
            if options[index] == "Cancelar" {
                alertController.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
            } else {
                action.setValue(imageView.image, forKey: "image")
                alertController.addAction(action)
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
