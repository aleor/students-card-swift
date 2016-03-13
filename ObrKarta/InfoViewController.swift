//
//  InfoViewController.swift
//  ObrKarta
//
//  Created by RA on 12/03/16.
//  Copyright © 2016 arvalea.com. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var data: Info?
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblBalanceInfo: UILabel!
    
    let cells = InfoCells()
    
    
    // MARK: - Table view data source
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        self.setup()
        }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func setup() {
        lblUserName.text = data?.Username
        lblBalanceInfo.text = data?.Balance
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        return UITableViewCell()
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
            }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            }

    
    
}
