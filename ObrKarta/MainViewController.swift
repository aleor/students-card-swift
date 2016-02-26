//
//  MainViewController.swift
//  ObrKarta
//
//  Created by RA on 21/02/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var PasswordTextBox: UITextField!
    
    @IBOutlet weak var loginTextBox: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func checkBalanceButton(sender: UIButton) {
        
        let login = loginTextBox.text
        
        let password = PasswordTextBox.text
        
        resultLabel.text = login! + " " + password!
        
        let URL: NSURL = NSURL(string: "http://obrkarta.ru/auth/")!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        
        request.HTTPMethod = "POST"
        
        let bodyData = "login=\(login!)&password=\(password!)"
        print(bodyData)
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                {
                    (response, data, error) in
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   }
