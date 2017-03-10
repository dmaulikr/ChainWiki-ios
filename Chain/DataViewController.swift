//
//  DataViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import SafariServices
import Firebase

class DataViewController: UIViewController {

    var dataLinks = [DataLink]()
    private let ref = FIREBASE_REF.child("links")
    private var refHandle: FIRDatabaseHandle?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handle = refHandle else { return }
        ref.removeObserver(withHandle: handle)
    }
    
    func setupViews() {
        
        title = "자료"
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func observeLinks() {
        
        refHandle = ref.observe(.childAdded, with: { snapshot in

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
        cell.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let link = dataLinks[indexPath.row].getURL()
        let title = dataLinks[indexPath.row].getTitle()
        
        guard let url = URL(string: link) else { return }
//        let vc = LinkViewController(url: url)
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
        vc.title = title
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}
