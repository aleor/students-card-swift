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
        
        getData(login, password: password)
    }
    
    func getData(login:String, password:String) {
        
        UIHelper.startIgnoringEvents()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityViewIndicator.startAnimating()
        
        
        // get data on logon and check if we were actually logged on
        Network.GetData(login, password: password, viewController: self, completionHandler: {result in
            
            UIHelper.stopIgnoringEvents()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.activityViewIndicator.stopAnimating()
            
            if let data = result as TFHpple? {
                
                // balance value means here that we were successfully logged on
                if let balance = HtmlParser.getBalance(data, viewController: self)  {
                    print(balance)
                    
                    if let username = HtmlParser.getUserName(data) {
                        print(username)
                    }
                    else {
                        print("Username not found")
                    }
                    
                    if let lastPurchases = HtmlParser.getPurchases(data) {
                        for purchase in lastPurchases {
                            print(purchase.Date + " " + purchase.Time + " " + purchase.Price)
                        }
                    }
                    
                }
                else {
                    // if not found - it means (most probably) that we were not logged on successfully
                    return
                }
            }
            else {
                UIHelper.displayAlert("Ошибка", alertMessage: "Ошибка при получении данных", viewController: self)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
