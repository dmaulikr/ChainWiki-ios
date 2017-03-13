//
//  TavernListCell.swift
//  Chain
//
//  Created by Jitae Kim on 12/5/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class TavernListTableCell: BaseCollectionViewCell {

    var tavernArray = [String]()

    var pageIndex: Int! {
        didSet {
            switch pageIndex {
            case 0:
                tavernArray = tavernNamesPart1
            case 1:
                tavernArray = tavernNamesPart2
            default:
                tavernArray = tavernNamesPart3
            }
            tableView.reloadData()
        }
    }
    
    private let tavernNamesPart1 = ["부도시", "성도", "현자의탑", "미궁산맥", "호수도시", "정령섬", "화염구령", "해풍의항구"]
    
    private let tavernNamesPart2 = ["새벽대해", "수인의대륙", "죄의대륙", "박명의대륙", "철연의대륙", "연대기대륙", "서가", "레무레스섬"]
    
    private let tavernNamesPart3 = ["성왕국", "현자의탑", "호수도시", "정령섬", "화염구령"]
    
    override func setupViews() {
        super.setupViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TavernListCell", bundle: nil), forCellReuseIdentifier: "TavernListCell")
    }

}

extension TavernListTableCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tavernArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TavernListCell") as! TavernListCell
        cell.tavernName.text = tavernArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard let selectedAbilityType = tableDelegate?.selectedIndex else { return }
//        
//        
//        let abilityVC = CollectionViewWithMenu(abilityType: currentArray[tableView.indexPathForSelectedRow!.row], selectedIndex: selectedAbilityType)
//        
//        tableDelegate?.navigationController?.pushViewController(abilityVC, animated: true)
        
        guard let pageIndex = pageIndex else { return }
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Tavern", bundle:nil)
        
//        let vc = storyBoard.instantiateViewController(withIdentifier: "TavernHomeView") as! TavernHomeView

        let tavernKR = tavernArray[indexPath.row]
        let tavernEN: String
//        vc.navTitle = tavern
        if pageIndex == 2 && indexPath.row != 0 {
            
            let tavern2 = "\(tavernKR)2"
            
            tavernEN = convertTavern(tavern: tavern2)
        }
        else {
            tavernEN = convertTavern(tavern: tavernKR)
        }
        
        let vc = TavernHomeView(tavernKR: tavernKR, tavernEN: tavernEN)
        tableDelegate?.navigationController?.pushViewController(vc, animated: true)
        collectionViewDelegate?.navigationController?.pushViewController(vc, animated: true)
    }
    
}


        


    


