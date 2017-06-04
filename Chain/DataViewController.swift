//
//  DataViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/7/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseDatabase
import FirebaseAnalytics

class DataViewController: UIViewController {

    var dataLinks = [DataLink]()
    private let ref = FIREBASE_REF.child("links")
    private var refHandle: DatabaseHandle?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.register(DataCell.self, forCellReuseIdentifier: "DataCell")
        return tableView
    }()

    deinit {
        guard let refHandle = refHandle else { return }
        ref.removeObserver(withHandle: refHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeLinks()
        setupViews()
//        downloadArcanaCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("DataView", screenClass: nil)
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
            if let handle = self.refHandle {
                self.ref.removeObserver(withHandle: handle)
            }
            self.tableView.reloadData()
        })
    }
    
    func downloadArcanaCount() {
        
        FIREBASE_REF.child("arcana").observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount)
            let arcanaCountButton = UIBarButtonItem(title: "아르카나 갯수: \(snapshot.childrenCount)", style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = arcanaCountButton
        })
    }

}

extension DataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataCell
        cell.linkTitleLabel.text = dataLinks[indexPath.row].getTitle()
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
