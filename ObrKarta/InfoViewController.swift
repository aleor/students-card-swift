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
    var selectedRow: Int?
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var lblBalanceInfo: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var balanceActivityIndicator: UIActivityIndicatorView!

    
    let cells = InfoCells()
    
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.registerNib(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Обновление данных...")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refreshControl)
        
        self.setup()
        self.table.reloadData()
        }

    
    func refresh(sender:AnyObject) {
        
        lblBalanceInfo.text = ""
        
        balanceActivityIndicator.startAnimating()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Services.getDataModel("10409969", password: "Evelina2005", viewController: self, completionHandler: {
        result in
            if (result != nil) {
            self.data = result
            self.balanceActivityIndicator.stopAnimating()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            self.setup()
                
            if self.refreshControl.refreshing
            {
                self.refreshControl.endRefreshing()
            }
            
            self.table.reloadData()
            
            }
            else {
                UIHelper.displayAlert("Не удалось обновить данные", alertMessage: "Попробуйте повторить попытку позднее", viewController: self)
            }
            
            if self.balanceActivityIndicator.isAnimating() {
                self.balanceActivityIndicator.stopAnimating()
            }
            
            if (UIApplication.sharedApplication().networkActivityIndicatorVisible) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func setup() {
        self.title = data?.Username
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedRow = indexPath.row
        print("Row: \(selectedRow)")
        
        
        
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
            
            if purchase.Content.count > 1 {
                cell.lblArrow.hidden = false
            }
         }
        
        return cell
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
            }
    
    

    
    
}
