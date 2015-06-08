//
//  DetailViewController.swift
//  BootCamp01
//
//  Created by 宍戸　俊哉 on 6/9/15.
//  Copyright (c) 2015 Shunya Shishido. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var entry: Entry!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string: entry.link as String!)
        var request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
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
