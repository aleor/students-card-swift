//
//  UIHelper.swift
//  ObrKarta
//
//  Created by RA on 07/03/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import UIKit

class UIHelper {
    
    class func displayAlert(titleMessage:String, alertMessage:String, viewController: UIViewController) -> Void {
        
        let alert = UIAlertController(title: titleMessage, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func startIgnoringEvents() -> Void {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    class func stopIgnoringEvents() -> Void {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
}
}
