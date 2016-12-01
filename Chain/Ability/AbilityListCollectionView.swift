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
    var selectedIndex: Int = 0
    let menuBar = MenuBar()
    var lastContentOffset = CGFloat(0)
    var index: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "어빌리티"
        setupMenuBar()
        collectionView.register(UINib(nibName: "AbilityListTableCell", bundle: nil), forCellWithReuseIdentifier: "AbilityListTableCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
//        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: 0).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let selectedCV = IndexPath(item: index, section: 0)
        let table = collectionView.cellForItem(at: selectedCV) as! AbilityListTableCell
        guard let selectedIndexPath = table.tableView.indexPathForSelectedRow else { return }
        table.tableView.deselectRow(at: selectedIndexPath, animated: true)
        
    }
    
    private func setupMenuBar() {
        
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        
        menuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        menuBar.backgroundColor = .black
        menuBar.homeController = self
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        self.index = menuIndex
        print("selected \(index)")
//        setTitleForIndex(menuIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarLeftAnchorConstraint?.constant = (scrollView.contentOffset.x + 20)/CGFloat(2)
 
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        self.index = indexPath.item
        print("selected \(index)")
//        setTitleForIndex(Int(index))
    }
    
//    fileprivate func setTitleForIndex(_ index: Int) {
//        if let titleLabel = navigationItem.titleView as? UILabel {
//            titleLabel.text = "  \(titles[index])"
//        }
//        
//    }
    

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
        
        let list = AbilityListDataSource().getAbilityList(index: indexPath.row)
        cell.abilityNames = list.titles
        cell.abilityImages = list.images
        cell.tableDelegate = self       
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    
    
}
