//
//  NewRunViewController.swift
//  finalProject
//
//  Created by Andrew Steinheiser on 11/15/16.
//  Copyright © 2016 AndrewSteinheiser. All rights reserved.
//

import UIKit

class NewRunViewController: UIViewController {
    
    @IBOutlet weak var runName: UITextField!
    @IBOutlet weak var runAddress: UITextField!
    @IBOutlet weak var runDesc: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var newRun = run?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.runName.layer.borderWidth = 1.0;
        self.runName.layer.borderColor = UIColor.lightGrayColor().CGColor;
        self.runName.layer.cornerRadius = 8;
        self.runDesc.layer.borderWidth = 1.0;
        self.runDesc.layer.borderColor = UIColor.lightGrayColor().CGColor;
        self.runDesc.layer.cornerRadius = 8;
        self.runAddress.layer.borderWidth = 1.0;
        self.runAddress.layer.borderColor = UIColor.lightGrayColor().CGColor;
        self.runAddress.layer.cornerRadius = 8;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            newRun = run(n: self.runName.text!, d: self.runDesc.text!, a: self.runAddress.text!)
        }
    }
}
