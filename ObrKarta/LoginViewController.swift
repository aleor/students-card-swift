//
//  LoginViewController.swift
//  ObrKarta
//
//  Created by RA on 09/03/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    
    @IBAction func loginClicked(sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
