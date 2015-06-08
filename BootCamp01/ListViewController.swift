//
//  ListViewController.swift
//  BootCamp01
//
//  Created by 宍戸　俊哉 on 6/8/15.
//  Copyright (c) 2015 Shunya Shishido. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate {
    
    let feedUrl = NSURL(string: "http://qiita.com/tags/swift/feed.atom")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "qiitaのRSS"
        
        var parser = NSXMLParser(contentsOfURL: feedUrl)
        parser?.delegate = self
        parser?.parse()
    }
    
    // atom parser
    // https://tools.ietf.org/html/rfc4287
    var currentElementName: String?
    let entryElementName = "entry"
    let titleElementName = "title"
    let urlElementName = "url"
    let authorElementName = "name"
    
    var entries = [Entry]()
    
    class Item {
        var title: String!
        var link: String!
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        currentElementName = nil
        if elementName == entryElementName {
            entries.append(Entry())
        } else {
            currentElementName = elementName
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if entries.count > 0 {
            var lastEntry = entries[entries.count - 1]
            if currentElementName == titleElementName {
                lastEntry.title = string
            } else if currentElementName == urlElementName {
                lastEntry.link = string
            } else if currentElementName == authorElementName {
                lastEntry.author = string
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListViewCell
        let item = entries[indexPath.row]
        
        cell.content(item.title, url: item.link, author: item.author, thumbnail: nil)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
