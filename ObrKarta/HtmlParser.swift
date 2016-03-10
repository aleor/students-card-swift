//
//  HtmlParser.swift
//  ObrKarta
//
//  Created by RA on 09/03/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import hpple

public class HtmlParser {
    
    // due to site specific, this method is also used to determine if login attempt was successfull
    public class func getBalance(data:TFHpple, viewController:UIViewController) -> String? {
        
        let xPathToBalanceInfoDiv = "//*[@id='nav']/div[1]/div/div/div[2]/div[1]/span[2]"
        
        if let balanceInfoDiv = data.searchWithXPathQuery(xPathToBalanceInfoDiv) as? [TFHppleElement] {
            
            if balanceInfoDiv.count == 0 {
                
                UIHelper.displayAlert("Информация не найдена", alertMessage: "Проверьте правильность логина и пароля", viewController: viewController)
                return nil
            }
            
            if let balance = balanceInfoDiv[0].text() {
                return balance
            }
        }
        
        return nil
    }


    public class func getUserName(data:TFHpple) -> String? {
    
        let xPathToLoginInfoDiv = "//*[@id='nav']/div[1]/div/div/div[2]/div[2]"
        
        if let loginInfoDiv = data.searchWithXPathQuery(xPathToLoginInfoDiv) as? [TFHppleElement] {
            
            if loginInfoDiv.count == 0 {
                return nil
            }
            
            if let loginInfoSpan = loginInfoDiv[0].firstChildWithClassName("sign-in__name") {
                if let attributes = loginInfoSpan.attributes {
                    for attribute in attributes {
                        if attribute.0 == "title" {
                            return (attribute.1 as? String)
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    public class func getPurchases(doc:TFHpple) -> [Purchase]? {
        
        var LastPurchases:[Purchase] = []
        
        let xPathToTable = "/html/body/div[5]/div/div[1]/div[1]/div/div"
        if let tableElements = doc.searchWithXPathQuery(xPathToTable) as? [TFHppleElement] {
            
            if tableElements.count == 0 {
                return nil
            }
            
            for tableElement in tableElements {
                if let tableRows = tableElement.childrenWithClassName("table_tr") as? [TFHppleElement]{
                    
                    if tableRows.count == 0 {
                        return nil
                    }
                    
                    // check how many rows we have and limit up to first 6 rows (including header)
                    let firstSixRows = tableRows.count > 6 ? 6 : tableRows.count
                    
                    // drop header, so now we have up to 5 latest purchases only
                    let firstFivePurchases = tableRows.prefix(firstSixRows).dropFirst()
                    
                    if (firstFivePurchases.count == 0) {
                        return nil
                    }
                    
                    for purchase in firstFivePurchases {
                        
                        if let purchaseDataColumns = purchase.childrenWithClassName("table_td") as? [TFHppleElement] {
                            
                            if purchaseDataColumns.count != 3 {
                                continue
                            }
                            
                            LastPurchases.append(parsePurchase(purchaseDataColumns))
                        }
                    }
                }
            }
        }
        
        return LastPurchases
    }
    
    private class func parsePurchase(purchaseDataColumns:[TFHppleElement]) -> Purchase {
        
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
        
        return thisPurchase
    }
    
    
}