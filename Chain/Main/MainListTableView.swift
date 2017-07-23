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
    var numberOfColumns = 2
    var arcana: Arcana?

    var arcanaView: ArcanaView? {
        didSet {
            tableView.reloadData()
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arcanaView == .main && indexPath.row == 0 {
            return tableView.frame.width * 1.5
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row), let arcana = arcana else { return UITableViewCell() }
        
        if arcanaView == .list || (arcanaView == .main && row == .arcana) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "arcanaCell") as! ArcanaCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
            
            cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .profile, completion: { arcanaImage in
                
                DispatchQueue.main.async {
                    if let imageCell = tableView.cellForRow(at: indexPath) as? ArcanaCell {
                        imageCell.arcanaImageView.animateImage(arcanaImage)
                    }
                }
            })
            
            cell.setupCell(arcana: arcana)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaMainImageCollectionViewCell") as! ArcanaMainImageCollectionViewCell
            
            cell.arcanaImageView.loadArcanaImage(arcana.getUID(), imageType: .main, completion: { arcanaImage in
                
                DispatchQueue.main.async {
                    if let imageCell = tableView.cellForRow(at: indexPath) as? ArcanaMainImageCollectionViewCell {
                        imageCell.arcanaImageView.animateImage(arcanaImage)
                    }
                }
            })
            
            return cell
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        guard let arcana = arcana else { return }
//        let vc = ArcanaDetail(arcana: arcana)
//        collectionViewDelegate?.navigationController?.pushViewController(vc, animated: true)
////        tableView.deselectRow(at: indexPath, animated: false)
//    }
}
