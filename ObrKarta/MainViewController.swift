//
//  MainViewController.swift
//  ObrKarta
//
//  Created by RA on 21/02/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import UIKit
import Alamofire
import hpple



class MainViewController: UIViewController {

    
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var PasswordTextBox: UITextField!
    
    @IBOutlet weak var loginTextBox: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func checkBalanceButton(sender: UIButton) {
        
        resultLabel.text = ""
        
        guard let login = loginTextBox.text where !login.isEmpty else {
            UIHelper.displayAlert("Ошибка входа", alertMessage: "Необходимо ввести логин", viewController: self)
            return
        }
        
        guard let password = PasswordTextBox.text where !password.isEmpty else {
            UIHelper.displayAlert("Ошибка входа", alertMessage: "Необходимо ввести пароль", viewController: self)
            return
        }
        
        UIHelper.startIgnoringEvents()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityViewIndicator.startAnimating()
        
        let URL: NSURL = NSURL(string: "http://obrkarta.ru/auth/")!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        
        request.HTTPMethod = "POST"
        
        let bodyData = "login=\(login)&password=\(password)"
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                {
                    (response, data, error) in
                    
                    //for debug
                    //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    UIHelper.stopIgnoringEvents()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityViewIndicator.stopAnimating()
                    
                    let doc = TFHpple(HTMLData: data!)
                    let xPath = "//*[@id='nav']/div[1]/div/div/div[2]/div[1]/span[2]"
                    if let elements = doc.searchWithXPathQuery(xPath) as? [TFHppleElement]
                    {
                        if elements.isEmpty {
                            UIHelper.displayAlert("Информация не найдена", alertMessage: "Проверьте правильность логина и пароля", viewController: self)
                            return
                        }
                        
                        for element in elements {
                            if let content = element.text()
                            {
                            print(content)
                                self.resultLabel.text = "Баланс: \(content)"
                            }
                        }
                    }
        }
        
    }
    
    
    
    ///html/body/div[5]/div/div[1]/div[1]/div/div
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   }
