//
//  SearchHistory.swift
//  Chain
//
//  Created by Jitae Kim on 9/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class SearchHistory: UIViewController {

    var arcanaArray = [Arcana]()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ArcanaTextCell.self, forCellReuseIdentifier: "ArcanaTextCell")

        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSearches()
    }

    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func updateSearches() {
        let uids = defaults.object(forKey: "recent") as? [String] ?? [String]().reversed()
        // todo. if i crash here, set some bool to true to check at next open and clear defaults.
//        defaults.removeObject(forKey: "recent")
        let group = DispatchGroup()
        
        if uids.count > 0 {
            var array = [Arcana]()
            
            for id in uids {
                group.enter()
                
                let ref = FIREBASE_REF.child("arcana/\(id)")
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        array.append(arcana)
                        
                    }
                    group.leave()
                    
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                self.arcanaArray = array.reversed()
                self.tableView.reloadData()
            })
            
        }

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if (segue.identifier == "searchToArcana") {
//            let arcana: Arcana
//
//            arcana = arcanaArray[tableView.indexPathForSelectedRow?.row]
//
//            let vc = segue.destination as! ArcanaDetail
//            vc.arcana = arcana
//        }
//    }

}

extension SearchHistory: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arcanaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaTextCell") as! ArcanaTextCell
        cell.nameLabel.text = arcanaArray[indexPath.row].getNameKR()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        let arcana: Arcana = arcanaArray[row]

        let vc = ArcanaDetail(arcana: arcana)
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
