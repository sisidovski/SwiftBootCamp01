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
        
        self.title = "qiita RSS"
        
        var parser = NSXMLParser(contentsOfURL: feedUrl)
        parser?.delegate = self
        parser?.parse()
    }
    
    // atom parser
    // https://tools.ietf.org/html/rfc4287
    var currentElementName: String?
    var contentHtmlString: String = ""
    let entryElementName   = "entry"
    let titleElementName   = "title"
    let urlElementName     = "url"
    let authorElementName  = "name"
    let contentElementName = "content"
    
    var entries = [Entry]()
    
    class Item {
        var title: String!
        var link: String!
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
    }
    
    func parseRss() -> Void {
        var parser = NSXMLParser(contentsOfURL: feedUrl)
        parser?.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        currentElementName = nil
        if elementName == entryElementName {
            entries.append(Entry())
        } else {
            currentElementName = elementName
        }
        contentHtmlString = ""
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (currentElementName == contentElementName) {
            let lastEntry = entries[entries.count - 1]
            // parse image src
            let pattern = "<img.*?src=\"(.*?)\""
            let range = NSMakeRange(0, count(contentHtmlString))
            let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
            if let matches = regex!.firstMatchInString(contentHtmlString, options: NSMatchingOptions.WithoutAnchoringBounds, range: range) {
                let imgUrl = ((contentHtmlString as NSString).substringWithRange(matches.rangeAtIndex(1)))
                lastEntry.imageUrl = imgUrl
            } else {
                lastEntry.imageUrl = nil
            }
        }
        currentElementName = nil
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if entries.count > 0 {
            var lastEntry = entries[entries.count - 1]
            if currentElementName == titleElementName {
                if lastEntry.title == nil {
                    lastEntry.title = string
                } else {
                    lastEntry.title = lastEntry.title + string!
                }
            } else if currentElementName == urlElementName {
                if lastEntry.link == nil {
                    lastEntry.link = string
                } else {
                    lastEntry.link = lastEntry.link + string!
                }
            } else if currentElementName == authorElementName {
                if lastEntry.author == nil {
                    lastEntry.author = string
                } else {
                    lastEntry.author = lastEntry.author + string!
                }
            } else if currentElementName == contentElementName {
                contentHtmlString = contentHtmlString + string!
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.tableView.reloadData()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        parseRss()
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
        return 20
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListViewCell
        let item = entries[indexPath.row]
        
        cell.content(item.title, url: item.link, author: item.author, thumbnail: item.imageUrl)

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = self.tableView.indexPathForSelectedRow()?.row
        var subViewController = segue.destinationViewController as! DetailViewController
        
        subViewController.entry = entries[selectedIndex!]
    }
}