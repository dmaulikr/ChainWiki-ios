//
//  ViewController.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Kanna

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var dataArray = ["안녕", "Bolivia"]
    
    var filteredArray = [String]()
    
    var shouldShowSearchResults = false
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomeCell
        
        if shouldShowSearchResults {
            cell.name.text = filteredArray[indexPath.row]
        }
        else {
            cell.name.text = dataArray[indexPath.row]
        }
        
        return cell
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country
            
            return (countryText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        tableView.reloadData()
    }
    
    func getHTML() {
        // Set the page URL we want to download
        
        _ = "https://xn--eckfza0gxcvmna6c.gamerch.com/年代記の剣士リヴェラ"
        let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
        let arcanaURL = "年代記の剣士リヴェラ"
        
        let encodedString = arcanaURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())

        let encodedURL = NSURL(string: "\(baseURL)\(encodedString!)")
        //print(encodedURL)
        // Try downloading it
        do {
            let html = try String(contentsOfURL: encodedURL!, encoding: NSUTF8StringEncoding)
            // print(htmlSource)
            
            // Kanna, search through htmㅣ
 
            if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
                // "#id"
//                for i in doc.css("#s") {
//                    print(i["@scan"])
//                }
                
                // Search for nodes by XPath
                //div[@class='ks']
                
                // Arcana Attribute Key
                //th[@class='   js_col_sort_desc ui_col_sort_asc']
                
                
                // Arcana Attribute Value
                //td[@class='   ']
                //span[@data-jscol_sort]"
                
                //td[@data-col]"
                
                
                for (link) in doc.xpath("//td[@data-col]") {
                    if let attribute = link.text {
                        //print(link.index)
                        print(attribute)
                    }
                }
            }
            


            
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
    }
    
    func parseHTML() {
        let html = "<html>...</html>"
        
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            print(doc.title)
            
            // Search for nodes by CSS
            for link in doc.css("a, link") {
                print(link.text)
                print(link["href"])
            }
            
            // Search for nodes by XPath
            for link in doc.xpath("//a | //link") {
                print(link.text)
                print(link["href"])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        configureSearchController()
        
        getHTML()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

