//
//  MainTableViewController.swift
//  Example
//
//  Created by Mathias Carignani on 5/19/15.
//  Copyright (c) 2015 Mathias Carignani. All rights reserved.
//

import UIKit
import MCMHeaderAnimated

class MainTableViewController: UITableViewController {
    
    private let transitionManager = MCMHeaderAnimated()
    
    private var elements: NSArray! = []
    private var lastSelected: NSIndexPath! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.elements = [
            ["img": "map","title":"Plans","byline":"upcoming trips"],
            ["img": "pen","title":"Suggestions","byline":"new suggestions"],
            ["img": "url_user","title":"My Profile","byline":"new suggestions"],
        ]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! MainTableViewCell
        
        cell.background.clipsToBounds = true
        cell.bkImage.image = UIImage(named:(self.elements.objectAtIndex(indexPath.row).objectForKey("img") as? String)!)
        cell.bkImage.contentMode = UIViewContentMode.ScaleAspectFill
        cell.title.text = (self.elements.objectAtIndex(indexPath.row).objectForKey("title") as? String)!
        
        cell.subTitle.text = (self.elements.objectAtIndex(indexPath.row).objectForKey("byline") as? String)!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height/CGFloat(self.elements.count)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewDetail" {
            self.lastSelected = self.tableView.indexPathForSelectedRow
            let element = self.elements.objectAtIndex(self.tableView.indexPathForSelectedRow!.row)
            
            let destination = segue.destinationViewController as! DetailViewController
            destination.element = element as! NSDictionary
            destination.transitioningDelegate = self.transitionManager
            
            self.transitionManager.destinationViewController = destination
        }
    }
    
}

extension MainTableViewController: MCMHeaderAnimatedDelegate {
    
    func headerView() -> UIView {
        // Selected cell
        let cell = self.tableView.cellForRowAtIndexPath(self.lastSelected) as! MainTableViewCell
        return cell.header
    }
    
    func headerCopy(subview: UIView) -> UIView {
        let cell = self.tableView.cellForRowAtIndexPath(self.lastSelected) as! MainTableViewCell
        let header = UIView(frame: cell.header.frame)
        header.backgroundColor = self.elements.objectAtIndex(self.lastSelected.row).objectForKey("color") as? UIColor
        
        let label = UILabel(frame: cell.title.frame)
        label.center =  cell.title.center
        label.textAlignment = .Center
        label.font = cell.title.font
        label.textColor = cell.title.textColor
        label.text = self.elements.objectAtIndex(self.lastSelected.row).objectForKey("title") as? String
        header .addSubview(label)
        return header
    }
}
