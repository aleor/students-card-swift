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

    var LastPurchases:[Purchase] = []
    
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
        
        Network.GetData(login, password: password, viewController: self, completionHandler: {result in
        
            UIHelper.stopIgnoringEvents()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.activityViewIndicator.stopAnimating()
            
            if let data = result as TFHpple? {
                print(data)
            }
            else {
                print("no")
            }
            
            
        })
        
        
        
        //print(response)
    }
    
    func getBalance(doc:TFHpple) {
        
        var isNameFound:Bool = false
        
        let xPathToBalanceInfoDiv = "//*[@id='nav']/div[1]/div/div/div[2]/div[1]/span[2]"
        
        if let balanceInfoDiv = doc.searchWithXPathQuery(xPathToBalanceInfoDiv) as? [TFHppleElement] {
            
            if balanceInfoDiv.count == 0 {
                //resultLabel.text = "Информация о балансе не найдена"
                UIHelper.displayAlert("Информация не найдена", alertMessage: "Проверьте правильность логина и пароля", viewController: self)
                return
            }
            
            if let balance = balanceInfoDiv[0].text() {
                //resultLabel.text! += balance
                print(balance)
            }
            else {
                //resultLabel.text = "Информация о балансе не найдена"
            }
            
        }
        
        let xPathToLoginInfoDiv = "//*[@id='nav']/div[1]/div/div/div[2]/div[2]"
        
        if let loginInfoDiv = doc.searchWithXPathQuery(xPathToLoginInfoDiv) as? [TFHppleElement] {
            
            if loginInfoDiv.count == 0 {
                //userNameLabel.text = "Не найдено"
                return
            }
            
            if let loginInfoSpan = loginInfoDiv[0].firstChildWithClassName("sign-in__name") {
                if let attributes = loginInfoSpan.attributes {
                    for attribute in attributes {
                        if attribute.0 == "title" {
                            //userNameLabel.text = attribute.1 as? String
                            isNameFound = true
                            print(attribute.1)
                        }
                    }
                }
            }
        }
        
        if (!isNameFound) {
            //userNameLabel.text = "Не найдено"
        }
        
    }
    
    func getPurchases(doc:TFHpple) {
        
        //lastPurchaseLabel.text = ""
        let xPathToTable = "/html/body/div[5]/div/div[1]/div[1]/div/div"
        if let tableElements = doc.searchWithXPathQuery(xPathToTable) as? [TFHppleElement] {
            
            if tableElements.count == 0 {
                //lastPurchaseLabel.text = "Информация о последних покупках не найдена"
                return
            }
            
            for tableElement in tableElements {
                if let tableRows = tableElement.childrenWithClassName("table_tr") as? [TFHppleElement]{
                    
                    if tableRows.count == 0 {
                        //lastPurchaseLabel.text = "Информация о последних покупках не найдена"
                        return
                    }
                    
                    // check how many rows we have and limit up to first 6 rows (including header)
                    let firstSixRows = tableRows.count > 6 ? 6 : tableRows.count
                    
                    // dropping header, so now we have up to 5 latest purchases only
                    let firstFivePurchases = tableRows.prefix(firstSixRows).dropFirst()
                    
                    if (firstFivePurchases.count == 0) {
                        //lastPurchaseLabel.text = "Информация о последних покупках не найдена"
                        return
                    }
                    
                    for purchase in firstFivePurchases {
                        
                        if let purchaseDataColumns = purchase.childrenWithClassName("table_td") as? [TFHppleElement] {
                            
                            if purchaseDataColumns.count != 3 {
                                //lastPurchaseLabel.text = "Неопознанный формат данных о последних покупках"
                                return
                            }
                            
                            parsePurchase(purchaseDataColumns)
                        }
                    }
                }
            }
        }
    }
    
    func parsePurchase(purchaseDataColumns:[TFHppleElement]) {
        
        let thisPurchase = Purchase()
        
        let purchaseDateInformation = purchaseDataColumns[0].text()
        let purchasePriceInformation = purchaseDataColumns[1].text()
        let purchaseContentInformation = purchaseDataColumns[2]
        
        //date and time
        let DateTimeArray = purchaseDateInformation.characters.split(" ").map(String.init)
        
        if DateTimeArray.count >= 2 {
            thisPurchase.Date = DateTimeArray[0]
            thisPurchase.Time = DateTimeArray[1]
        }
        else
        {
            thisPurchase.Date = purchaseDateInformation
        }
        
        //price
        thisPurchase.Price = purchasePriceInformation
        
        //content
        if let headers = purchaseContentInformation.childrenWithTagName("b") as? [TFHppleElement] {
            if let header = headers.first {
                thisPurchase.ContentHeader = header.text()
                //print("Header = " + header.text())
            }
        }
        
        if let menuLists = purchaseContentInformation.childrenWithTagName("ul") as? [TFHppleElement] {
            for menuList in menuLists {
                if let menuItems = menuList.childrenWithTagName("li") as? [TFHppleElement] {
                    for menuItem in menuItems {
                        thisPurchase.Content.append(menuItem.text())
                        //print(menuItem.text())
                    }
                }
                
            }
            
        }
        
        if let childs = purchaseContentInformation.children as? [TFHppleElement] {
            for child in childs {
                if let singlePurchase = child.content {
                    let singlePurchaseItem = singlePurchase.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if singlePurchaseItem.characters.count > 0 {
                        thisPurchase.Content.append(singlePurchaseItem)
                        //print(singlePurchaseItem)
                    }
                }
            }
        }
        
        LastPurchases.append(thisPurchase)
        
        //lastPurchaseLabel.text! += purchaseDateInformation + " = " + purchasePriceInformation
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
