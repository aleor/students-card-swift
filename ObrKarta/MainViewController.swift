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
    
    var LastPurchases:[Purchase] = []
    
    @IBAction func checkBalanceButton(sender: UIButton) {
        
        resultLabel.text = ""
        lastPurchaseLabel.text = ""
        
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
                
                self.getPurchases(doc)
                
            })
    }
    
    func getPurchases(doc:TFHpple) {
    
        lastPurchaseLabel.text = ""
        let xPathToTable = "/html/body/div[5]/div/div[1]/div[1]/div/div"
        if let tableElements = doc.searchWithXPathQuery(xPathToTable) as? [TFHppleElement] {
            
            if tableElements.count == 0 {
                lastPurchaseLabel.text = "Информация о последних покупках не найдена"
                return
                }
            
            for tableElement in tableElements {
                if let tableRows = tableElement.childrenWithClassName("table_tr") as? [TFHppleElement]{
                    
                    if tableRows.count == 0 {
                        lastPurchaseLabel.text = "Информация о последних покупках не найдена"
                        return
                    }
                    
                    // check how many rows we have and limit up to first 6 rows (including header)
                    let firstSixRows = tableRows.count > 6 ? 6 : tableRows.count
                    
                    // dropping header, so now we have up to 5 latest purchases only
                    let firstFivePurchases = tableRows.prefix(firstSixRows).dropFirst()
                    
                    if (firstFivePurchases.count == 0) {
                        lastPurchaseLabel.text = "Информация о последних покупках не найдена"
                        return
                    }
                    
                    for purchase in firstFivePurchases {
                        
                        if let purchaseDataColumns = purchase.childrenWithClassName("table_td") as? [TFHppleElement] {
                            
                            if purchaseDataColumns.count != 3 {
                                lastPurchaseLabel.text = "Неопознанный формат данных о последних покупках"
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
        
        let DateTimeArray = purchaseDateInformation.characters.split(" ").map(String.init)
        
        if DateTimeArray.count >= 2 {
            thisPurchase.Date = DateTimeArray[0]
            thisPurchase.Time = DateTimeArray[1]
        }
        else
        {
            thisPurchase.Date = purchaseDateInformation
        }
        
        thisPurchase.Price = purchasePriceInformation
        
        LastPurchases.append(thisPurchase)
        
        //print(purchaseDateInformation)
        //print(purchasePriceInformation)
        //print(purchaseContentInformation.raw)
        
        if let headers = purchaseContentInformation.childrenWithTagName("b") as? [TFHppleElement] {
            if let header = headers.first {
                thisPurchase.ContentHeader = header.text()
                print("Header = " + header.text())
            }
        }
        
        if let menuLists = purchaseContentInformation.childrenWithTagName("ul") as? [TFHppleElement] {
            for menuList in menuLists {
                if let menuItems = menuList.childrenWithTagName("li") as? [TFHppleElement] {
                    for menuItem in menuItems {
                        thisPurchase.Content.append(menuItem.text())
                        print(menuItem.text())
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
                        print(singlePurchaseItem)
                    }
                }
            }
        }
        
        lastPurchaseLabel.text! += purchaseDateInformation + " = " + purchasePriceInformation
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   }
