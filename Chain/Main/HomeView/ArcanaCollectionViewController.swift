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
    var observedRefs = [DatabaseReference]()
    
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
        
        view.backgroundColor = .white
        setupTitle()
        
        view.addSubview(collectionView)
        
        collectionView.anchorEdgesToSuperview()
    }
    
    func setupTitle() {
        
        switch arcanaSection {
            
        case .reward:
            title = "보상"
        case .festival:
            title = "페스티벌"
        case .new:
            title = "최신"
        case .legend:
            title = "레전드"
        }
    }
    
    func reloadView() {
        collectionView.fadeIn()
        collectionView.reloadData()
    }
    
    func syncArcana() {
        
        switch arcanaSection {
            
        case .reward, .legend:
            observeArcanaAtRef(arcanaSection)
            
        case .festival:
            observeFestivalArcana()
            
        case .new:
            observeArcana()
        }

    }
    
    func observeArcana() {
        
        let ref = FIREBASE_REF.child("arcana")
        ref.queryLimited(toLast: 10).observe(.childAdded, with: { snapshot in
            //            ref.observe(.childAdded, with: { snapshot in
            if let arcana = Arcana(snapshot: snapshot) {
                
                self.concurrentArcanaQueue.async(flags: .barrier) {
                    self._arcanaArray.insert(arcana, at: 0)
                    DispatchQueue.main.async {
                        self.reloadView()
                    }
                }
            }
            
        })
        
        ref.observe(.childChanged, with: { snapshot in
            
            let arcanaID = snapshot.key
            
            if let arcana = Arcana(snapshot: snapshot) {
                
                DispatchQueue.global().async {
                    
                    if let index = self.arcanaArray.index(where: {$0.getUID() == arcanaID}) {
                        self.concurrentArcanaQueue.async(flags: .barrier) {
                            self._arcanaArray[index] = arcana
                            DispatchQueue.main.async {
                                self.reloadView()
                            }
                        }
                    }
                    
                }
            }
            
        })
        
        ref.observe(.childRemoved, with: { snapshot in
            
            let arcanaID = snapshot.key
            
            DispatchQueue.global().async {
                
                if let index = self.arcanaArray.index(where: {$0.getUID() == arcanaID}) {
                    
                    self.concurrentArcanaQueue.async(flags: .barrier) {
                        self._arcanaArray.remove(at: index)
                        DispatchQueue.main.async {
                            self.reloadView()
                        }
                    }
                }
                
            }
            
        })
    }
    
    func observeArcanaIdsWith(data: [String]) {
        
        let uid = data
        
        let group = DispatchGroup()
        
        for id in uid {
            group.enter()
            
            let ref = ARCANA_REF.child(id)
            self.observedRefs.append(ref)
            ref.observe(.value, with: { (snapshot) in
                
                if let arcana = Arcana(snapshot: snapshot) {
                    
                    self.concurrentArcanaQueue.async(flags: .barrier) {
                        self._arcanaArray.append(arcana)
                    }
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            self.collectionView.reloadData()
            self.collectionView.fadeIn()
        })
    }
    
    func observeArcanaAtRef(_ arcanaSection: ArcanaSection) {
        
        let ref: DatabaseReference
        
        if arcanaSection == .reward {
            ref = REWARD_REF
        }
        else {
            ref = LEGEND_REF
        }
        
        FirebaseApi.shared.arcanaIDsAt(ref) { (data, error) in
            
            if error == nil {
                self.observeArcanaIdsWith(data: data)
            }
        }
        
    }

    func observeFestivalArcana() {
        
        FirebaseApi.shared.arcanaIDsOrderedByValue(FESTIVAL_REF) { (data, error) in
            
            if error == nil {
                self.observeArcanaIdsWith(data: data)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arcanaArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArcanaPreviewWrapperCollectionViewCell", for: indexPath) as! ArcanaPreviewWrapperCollectionViewCell
        
        if indexPath.row < arcanaArray.count {
            
            let arcana = arcanaArray[indexPath.row]
            
            cell.arcanaPreviewView.setupCell(arcana: arcana)
            cell.arcanaID = arcana.getUID()
            cell.arcanaPreviewView.arcanaImageView.loadArcanaImage(arcanaID: arcana.getUID(), urlString: arcana.iconURL, completion: { (arcanaID, arcanaImage) in
                
                if let cellID = cell.arcanaID, cellID == arcanaID {
                    DispatchQueue.main.async {
                        cell.arcanaPreviewView.arcanaImageView.animateImage(arcanaImage)
                    }
                }

            })
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if traitCollection.horizontalSizeClass == .compact {
            return CGSize(width: collectionView.frame.width, height: 90)
        }
        return CGSize(width: 200, height: 200)
    }
    
}
