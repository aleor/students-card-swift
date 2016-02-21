//
//  MainViewController.swift
//  ObrKarta
//
//  Created by RA on 21/02/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var PasswordTextBox: UITextField!
    
    @IBOutlet weak var loginTextBox: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func checkBalanceButton(sender: UIButton) {
        
        let login = loginTextBox.text
        
        let password = PasswordTextBox.text
        
        resultLabel.text = login! + " " + password!
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   }
