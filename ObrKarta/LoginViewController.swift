//
//  LoginViewController.swift
//  ObrKarta
//
//  Created by RA on 09/03/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import UIKit
import Alamofire
import hpple

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    
    @IBAction func loginClicked(sender: UIButton) {
        
        guard let login = loginTextBox.text where !login.isEmpty else {
            UIHelper.displayAlert("Ошибка входа", alertMessage: "Необходимо ввести логин", viewController: self)
            return
        }
        
        guard let password = passwordTextBox.text where !password.isEmpty else {
            UIHelper.displayAlert("Ошибка входа", alertMessage: "Необходимо ввести пароль", viewController: self)
            return
        }
        
        UIHelper.startIgnoringEvents()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityViewIndicator.startAnimating()
        
        Services.getDataModel(login, password: password, viewController: self)
        
        UIHelper.stopIgnoringEvents()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.activityViewIndicator.stopAnimating()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
