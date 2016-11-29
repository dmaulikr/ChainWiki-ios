//
//  AbilityListCollectionView.swift
//  Chain
//
//  Created by Jitae Kim on 11/28/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class AbilityListCollectionView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var pages = [0,1]
    fileprivate var abilityNames = [String]()
    fileprivate var abilityImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "AbilityListTableCell", bundle: nil), forCellWithReuseIdentifier: "AbilityListTableCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        let menuBar = MenuBar()
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        
        menuBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true

        menuBar.backgroundColor = .red
        
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

extension AbilityListCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AbilityListTableCell", for: indexPath) as! AbilityListTableCell
        print("OI")
        
        let list = AbilityListDataSource().getAbilityList(index: indexPath.row)
        cell.abilityNames = list.titles
        cell.abilityImages = list.images

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 100)
    }
    
}
