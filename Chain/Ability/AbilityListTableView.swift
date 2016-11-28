//
//  AbilityListTableView.swift
//  Chain
//
//  Created by Jitae Kim on 11/27/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityListTableView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var pageIndex: Int!
    
    var abilityNames = [String]()
    var abilityImages = [UIImage]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AbilityListCell", bundle: nil), forCellReuseIdentifier: "abilityListCell")
        getAbilityList()
    }

    func getAbilityList() {
        
        let list = AbilityListDataSource().getAbilityList(index: pageIndex)
        abilityNames = list.titles
        abilityImages = list.images
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AbilityListTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilityNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "abilityListCell") as! AbilityListCell
        cell.abilityName.text = abilityNames[indexPath.row]
        cell.abilityImage.image = abilityImages[indexPath.row]
        
        return cell
    }
}
