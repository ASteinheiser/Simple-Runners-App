//
//  TableViewController.swift
//  finalProject
//
//  Created by Andrew Steinheiser on 11/15/16.
//  Copyright © 2016 AndrewSteinheiser. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var runTable: UITableView!
    
    var runList = runData()
    var indexPath = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTable.rowHeight = 90
        
        if let savedRuns = runList.loadRuns() {
            for run in savedRuns {
                runList.add(run)
            }
            if savedRuns == [] {
                runList.loadSampleData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runList.size()
    }
    
    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        self.indexPath = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier("runCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = runList.getName(indexPath.row);
        cell.textLabel?.font = cell.textLabel?.font.fontWithSize(25)
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        runList.delete(indexPath.row)
        runList.saveRuns()
        runTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showDetail"){
            let selectedIndex: NSIndexPath = self.runTable.indexPathForCell(sender as! UITableViewCell)!
            
            if let DetailViewController: DetailViewController = segue.destinationViewController as? DetailViewController {
                DetailViewController.selectedName = runList.getName(selectedIndex.row);
                DetailViewController.selectedDesc = runList.getDetail(selectedIndex.row);
                DetailViewController.selectedAddress = runList.getAddress(selectedIndex.row);
            }
        }
    }
    
    @IBAction func unwindSeg(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? NewRunViewController, newRun = sourceViewController.newRun {
            
            let newIndexPath = NSIndexPath(forRow: runList.size(), inSection: 0)
            runList.add(newRun)
            runTable.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        else if let sourceViewController = sender.sourceViewController as? DetailViewController, newRun = sourceViewController.newRun {
            
            let newIndexPath = self.runTable.indexPathForSelectedRow
            runList.replace(newRun, i: (newIndexPath?.row)!)
            runTable.reloadData()
        }
        
        runList.saveRuns()
    }
}