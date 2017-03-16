//
//  ArcanaEditHistory.swift
//  Chain
//
//  Created by Jitae Kim on 10/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ArcanaEditList: UIViewController {

    fileprivate let arcanaID: String
    fileprivate var arcanaEditsArray = [ArcanaEditModel]()

    fileprivate lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ArcanaEditListCell.self, forCellReuseIdentifier: "ArcanaEditListCell")
        
        return tableView
    }()
    
    fileprivate let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "수정 기록 없음!"
        label.textColor = Color.textGray
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var edits = [String]()
    fileprivate var names = [String]()
    fileprivate var editor: String?
    
    init(arcanaID: String) {
        self.arcanaID = arcanaID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getEdits()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        title = "수정 기록"
        
        view.addSubview(tableView)
        view.addSubview(tipLabel)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        tipLabel.anchorCenterSuperview()
        
        let backButton = UIBarButtonItem(title: "이전", style:.plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton

    }
    
    private func getEdits() {

        let ref = FIREBASE_REF.child("arcanaEdit").child(arcanaID)
        ref.observeSingleEvent(of: .value, with: { snapshot in

            guard let editData = snapshot.value as? Dictionary<String, AnyObject> else { return }
                
                for child in editData.reversed() {
                    
                    let date = child.value["date"] as! String
                    let name = child.value["nickName"] as! String
                    let editUID = child.value["uid"] as! String
                    
                    let updateRef = ref.child(editUID).child("update")
                    updateRef.observeSingleEvent(of: .value, with: { snapshot in
                        var indexes = [IndexPath]()
                        let arcana = ArcanaEdit(snapshot: snapshot)
                        self.arcanaEditsArray.insert(ArcanaEditModel(a: arcana, id: editUID, name: name, ref: ref.child(child.key), d: date), at: 0)
                        indexes.append(IndexPath(row: 0, section: 0))
                        
                        self.tableView.insertRows(at: indexes, with: UITableViewRowAnimation.automatic)
                    })
                    
                }
            
        })
        
    }

}

extension ArcanaEditList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arcanaEditsArray.count == 0 {
            tableView.alpha = 0
            tipLabel.alpha = 1
        }
        else {
            tableView.alpha = 1
            tipLabel.alpha = 0
        }
        
        return arcanaEditsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaEditListCell") as! ArcanaEditListCell
        
        cell.dateLabel.text = arcanaEditsArray[indexPath.row].date
        cell.nameLabel.text = arcanaEditsArray[indexPath.row].editorName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let arcanaEdit: ArcanaEditModel
        arcanaEdit = arcanaEditsArray[indexPath.row]
        
        let vc = ArcanaEditHistory(arcana: arcanaEdit)
        navigationController?.pushViewController(vc, animated: true)
    }

}
