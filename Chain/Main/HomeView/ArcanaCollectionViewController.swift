//
//  ArcanaCollectionViewController.swift
//  Chain
//
//  Created by Jitae Kim on 8/22/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase

class ArcanaCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let arcanaSection: ArcanaSection
    var initialLoad = true
    let concurrentArcanaQueue =
        DispatchQueue(
            label: "com.jk.cckorea.arcanaArrayQueue",
            attributes: .concurrent)

    
    // Not thread-safe
    var _arcanaArray: [Arcana] = []
    
    // Thread-safe
    var arcanaArray: [Arcana] {
        get {
            var arcanaCopy: [Arcana]!
            concurrentArcanaQueue.sync {
                arcanaCopy = self._arcanaArray
            }
            return arcanaCopy
        }
        set {
            _arcanaArray = newValue
        }
    }
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .white
        collectionView.alpha = 0
        
        collectionView.register(UINib(nibName: "ArcanaPreviewWrapperCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArcanaPreviewWrapperCollectionViewCell")

        return collectionView
    }()
    
    init(arcanaSection: ArcanaSection) {
        self.arcanaSection = arcanaSection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        syncArcana()
    }
    
    func setupViews() {
        
        view.addSubview(collectionView)
        
        collectionView.anchorEdgesToSuperview()
    }
    
    func syncArcana() {
        
        switch arcanaSection {
        case .reward:
            title = "보상"
            break
        case .festival:
            title = "페스티벌"
            getFestivalArcana()
            break
        case .new:
            title = "최신"
            break
        case .legend:
            title = "레전드"
            break
        }
        
    }
    
    func getFestivalArcana() {
        
        let ref = FIREBASE_REF.child("festival")
        
        ref.queryOrderedByValue().observeSingleEvent(of: .value, with: { snapshot in
            
            var uid = [String]()
            
            for child in snapshot.children {
                let arcanaID = (child as AnyObject).key as String
                uid.append(arcanaID)
            }
            
            let group = DispatchGroup()
            
            for id in uid {
                group.enter()
                
                let ref = ARCANA_REF.child(id)
                
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    if let arcana = Arcana(snapshot: snapshot) {
                        
                        self.concurrentArcanaQueue.async(flags: .barrier) {
                            self._arcanaArray.append(arcana)
                        }

                    }
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                self.initialLoad = false
                self.collectionView.fadeIn()
                self.collectionView.reloadData()
            })
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arcanaArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaPreviewWrapperCollectionViewCell", for: indexPath) as! ArcanaPreviewWrapperCollectionViewCell
        
        cell.arcanaPreviewView.arcanaNameKRLabel.text = "아르카나"
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if traitCollection.horizontalSizeClass == .compact {
            return CGSize(width: collectionView.frame.width, height: 90)
        }
        return CGSize(width: 200, height: 200)
    }
    
}
