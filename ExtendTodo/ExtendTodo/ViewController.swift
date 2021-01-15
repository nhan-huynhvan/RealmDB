//
//  ViewController.swift
//  ExtendTodo
//
//  Created by Nhan Huynh on 1/15/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.isLogged() == true {
            message.text = Constants.group
        }
    }
}

