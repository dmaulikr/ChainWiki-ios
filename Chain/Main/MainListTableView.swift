//
//  MainListTableView.swift
//  Chain
//
//  Created by Jitae Kim on 3/30/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class MainListTableView: UICollectionViewCell {

    weak var collectionViewDelegate: ArcanaViewController?
    
    var arcana: Arcana? {
        didSet {
            tableView.reloadData()
        }
    }
    var arcanaView: ArcanaView?
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 90
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.register(UINib(nibName: "ArcanaCell", bundle: nil), forCellReuseIdentifier: "arcanaCell")
        tableView.register(ArcanaMainImageCollectionViewCell.self, forCellReuseIdentifier: "ArcanaMainImageCollectionViewCell")
        
        return tableView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(tableView)
        
        tableView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }


}

extension MainListTableView: UITableViewDelegate, UITableViewDataSource {
    
    private enum Row: Int {
        case image
        case arcana
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arcanaView == .list {
            return 1
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row), let arcana = arcana else { return UITableViewCell() }
        
        if arcanaView == .list || (arcanaView == .main && row == .arcana) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
            
            cell.arcanaNickKR.text = nil
            cell.arcanaNickJP.text = nil
            cell.arcanaImage.image = nil
            
            cell.arcanaID = arcana.getUID()
            print(arcana.getUID())
            cell.arcanaImage.loadArcanaImage(arcana.getUID(), imageType: .profile, sender: cell)
            
            // check if arcana has only name, or nickname.
            if let nnKR = arcana.getNicknameKR() {
                cell.arcanaNickKR.text = nnKR
            }
            if let nnJP = arcana.getNicknameJP() {
                cell.arcanaNickJP.text = nnJP
            }
            cell.arcanaNameKR.text = arcana.getNameKR()
            cell.arcanaNameJP.text = arcana.getNameJP()
            
            cell.arcanaRarity.text = "#\(arcana.getRarity())★"
            cell.arcanaGroup.text = "#\(arcana.getGroup())"
            cell.arcanaWeapon.text = "#\(arcana.getWeapon())"
            
            if let a = arcana.getAffiliation() {
                if a != "" {
                    cell.arcanaAffiliation.text = "#\(a)"
                }
                
            }
            cell.numberOfViews.text = "조회 \(arcana.getNumberOfViews())"
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaMainImageCollectionViewCell") as! ArcanaMainImageCollectionViewCell
            cell.arcanaImageView.image = nil
            
            cell.arcanaID = arcana.getUID()
            cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .main, sender: cell)
            
            return cell

        }

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let arcana = arcana else { return }
        let vc = ArcanaDetail(arcana: arcana)
        collectionViewDelegate?.navigationController?.pushViewController(vc, animated: true)
//        tableView.deselectRow(at: indexPath, animated: false)
    }
}
