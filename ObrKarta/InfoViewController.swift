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
    
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    
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
        for purchase in (data?.Purchases)! {
            cells.append(InfoCells.HeaderItem(value:purchase.ContentHeader))
            for item in purchase.Content {
                cells.append(InfoCells.Item(value:item))
            }
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cells.items.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = self.cells.items[indexPath.row]
        let value = item.value as? String
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("infoCell") {
            cell.textLabel?.text = value
            
            if item as? InfoCells.HeaderItem != nil {
                //cell.backgroundColor = UIColor.blueColor()
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = self.cells.items[indexPath.row]
        
        if item is InfoCells.HeaderItem {
            return 60
        } else if (item.isHidden) {
            return 0
        } else {
            return 44
        }
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.cells.items[indexPath.row]
        
        if item is InfoCells.HeaderItem {
            if self.selectedHeaderIndex == nil {
                self.selectedHeaderIndex = indexPath.row
            } else {
                self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                self.selectedHeaderIndex = indexPath.row
            }
            
            if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                self.cells.collapse(previouslySelectedHeaderIndex)
            }
            
            if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                self.cells.expand(self.selectedHeaderIndex!)
            } else {
                self.selectedHeaderIndex = nil
                self.previouslySelectedHeaderIndex = nil
            }
            
            self.table.beginUpdates()
            self.table.endUpdates()
            
        } else {
            if indexPath.row != self.selectedItemIndex {
                let cell = self.table.cellForRowAtIndexPath(indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                
                if let selectedItemIndex = self.selectedItemIndex {
                    let previousCell = self.table.cellForRowAtIndexPath(NSIndexPath(forRow: selectedItemIndex, inSection: 0))
                    previousCell?.accessoryType = UITableViewCellAccessoryType.None
                }
                
                self.selectedItemIndex = indexPath.row
            }
        }
    }

    
    
}
