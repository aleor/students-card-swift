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
    
    @IBOutlet weak var lastPurchaseLabel: UILabel!
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
        
        Alamofire.request(.POST,
        "http://obrkarta.ru/auth/",
        parameters: ["login":"\(login)", "password":"\(password)"],
        encoding: .URL, headers: nil)
        .validate()
            .responseString(encoding: NSUTF8StringEncoding, completionHandler: {(response) -> Void in
                
                //for debug
                //print(NSString(data: response.data!, encoding: NSUTF8StringEncoding))
                
                
                guard response.result.isSuccess else {
                    print("Не удается соединиться с сервером: \(response.result.error)")
                    UIHelper.displayAlert("Нет соединения", alertMessage: "Попробуйте повторить запрос позднее", viewController: self)
                    //completion(nil)
                    return
                }
                
                UIHelper.stopIgnoringEvents()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityViewIndicator.stopAnimating()
                
                let doc = TFHpple(HTMLData: response.data!)
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
                
                self.parsePurchases(doc)
                
            })
    }
    
    func parsePurchases(doc:TFHpple) {
        let xPath = "/html/body/div[5]/div/div[1]/div[1]/div/div"
        if let elements = doc.searchWithXPathQuery(xPath) as? [TFHppleElement] {
            if elements.isEmpty {
                print("empty")
            }
            
            for element in elements {
                if let content = element.childrenWithClassName("table_tr") {
                    print(content)
                }
            }
        }
        else {
           print("no elements")
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
