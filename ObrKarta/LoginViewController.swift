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

    var dataModel = Info()
    
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
        
        Services.getDataModel(login, password: password, viewController: self, completionHandler: {infoModel in
            
            UIHelper.stopIgnoringEvents()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.activityViewIndicator.stopAnimating()
            
            if let data = infoModel as Info? {
                self.dataModel = data
                self.performSegueWithIdentifier("showInfoViewController", sender: self)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                UIHelper.displayAlert("Информация не найдена", alertMessage: "Проверьте правильность логина и пароля", viewController: self)
                })
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showInfoViewController" {
        let infoViewController = (segue.destinationViewController as! InfoViewController)
            infoViewController.data = dataModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
