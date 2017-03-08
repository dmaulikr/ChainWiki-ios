//
//  DataViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import SafariServices


class DataViewController: UIViewController {

    var dataLinks = [DataLink]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DataCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        observeLinks()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let row = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: row, animated: true)
        
    }
    
    func setupViews() {
        
        title = "자료"
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func observeLinks() {
        
        let ref = FIREBASE_REF.child("links")
        
        ref.observe(.childAdded, with: { snapshot in
            print(snapshot.value)
            // each link will have two children. one for the link, one for the korean text to be displayed
            if let linkData = snapshot.value as? Dictionary<String, AnyObject> {
                
                if let linkURL = linkData["url"] as? String, let title = linkData["title"] as? String {
                    let link = DataLink(url: linkURL, title: title)
                    self.dataLinks.append(link)
                    
                }
            }
            
        })
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            self.tableView.reloadData()
        })
    }

}

extension DataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = dataLinks[indexPath.row].getTitle()
        cell.textLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let link = dataLinks[indexPath.row].getURL()
        if let url = URL(string: link) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true)
        }
        
    }
    
}
