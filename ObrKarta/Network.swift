//
//  Network.swift
//  ObrKarta
//
//  Created by RA on 09/03/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import Alamofire
import hpple

public class Network {
    
    class func getData(login:String, password:String, viewController: UIViewController, completionHandler: (TFHpple?)->Void) {
        
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
                    UIHelper.displayAlert("Нет соединения", alertMessage: "Попробуйте повторить запрос позднее", viewController: viewController)
                    completionHandler(nil)
                    return
                }
                
                completionHandler(TFHpple(HTMLData: response.data!))
                
            })
    }
}
