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
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let numberOfPurchases = data?.Purchases.count {
            return numberOfPurchases
        }
        else {
            return 0
        }
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! InfoCells
        
        if let purchase = data?.Purchases[indexPath.row] {
            cell.lblDate.text = purchase.Date
            cell.lblTime.text = purchase.Time
            cell.lblPrice.text = purchase.Price
            if !purchase.ContentHeader.isEmpty {
            cell.lblTitle.text = purchase.ContentHeader
            }
            else {
                cell.lblTitle.text = purchase.Content[0]
            }
         }
        
        return cell
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
            }
    
    

    
    
}
