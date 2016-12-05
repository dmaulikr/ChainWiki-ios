//
//  AbilityListTableCell.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityListTableCell: UICollectionViewCell {

//    @IBOutlet weak var tableView: UITableView!
    var tableView = UITableView()
    var pageIndex: Int!
    var abilityNames = [String]()
    var abilityImages = [UIImage]()
//    var tableDelegate: AbilityListCollectionView?
    var tableDelegate: CollectionViewWithMenu?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTableView() {
        
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.register(UINib(nibName: "AbilityListCell", bundle: nil), forCellReuseIdentifier: "abilityListCell")
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 90
        tableView.sectionHeaderHeight = 1
        
    }

}

extension AbilityListTableCell: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilityNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "abilityListCell") as! AbilityListCell
        cell.abilityName.text = abilityNames[indexPath.row]
        cell.abilityImage.image = abilityImages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let selectedAbilityType = tableDelegate?.selectedIndex else { return }
        
        
        let abilityVC = CollectionViewWithMenu(abilityType: abilityNames[tableView.indexPathForSelectedRow!.row], selectedIndex: selectedAbilityType)
        
        
//        abilityVC.abilityType =
        tableDelegate?.navigationController?.pushViewController(abilityVC, animated: true)

    
    }
    
}
