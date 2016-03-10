//
//  Services.swift
//  ObrKarta
//
//  Created by RA on 10/03/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import UIKit
import hpple

public class Services {
    
    class func getDataModel(login: String, password: String, viewController:UIViewController) -> Info? {
        
        let info = Info()
        
        // get data on logon and check if we were actually logged on
        Network.getData(login, password: password, viewController: viewController, completionHandler: {result in
            
            if let data = result as TFHpple? {
                
                // balance value means here that we were successfully logged on
                if let balance = HtmlParser.getBalance(data, viewController: viewController)  {
                    info.Balance = balance
                    print(balance)
                    
                    if let username = HtmlParser.getUserName(data) {
                        info.Username = username
                        print(username)
                    }
                    else {
                        print("Username not found")
                    }
                    
                    if let lastPurchases = HtmlParser.getPurchases(data) {
                        info.Purchases = lastPurchases
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
                UIHelper.displayAlert("Ошибка", alertMessage: "Ошибка при получении данных", viewController: viewController)
            }
        })
        return info
    }
}