//
//  LoginViewController.swift
//  Todo
//
//  Created by Nhan Huynh on 1/14/21.
//

import UIKit
import KeychainSwift
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.borderStyle = UITextField.BorderStyle.roundedRect
        password.borderStyle = UITextField.BorderStyle.roundedRect
        mainScreen()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let username = userName.text, let password = password.text {
            let user = User()
            user.username = username
            user.password = password
            user.login()
            mainScreen()
        }
    }
    
    private func mainScreen() {
        if User.isLogged() {
            performSegue(withIdentifier: Constants.categoryScreen, sender: self)
        }
    }
}

