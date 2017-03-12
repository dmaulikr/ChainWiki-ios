//
//  ArcanaPeekPreview.swift
//  Chain
//
//  Created by Jitae Kim on 3/11/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ArcanaPeekPreview: UIViewController {

    let arcana: Arcana
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 20
        tableView.estimatedRowHeight = 160
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets.zero
        
        tableView.register(ArcanaImageCell.self, forCellReuseIdentifier: "ArcanaImageCell")
        tableView.register(ArcanaButtonsCell.self, forCellReuseIdentifier: "ArcanaButtonsCell")
        tableView.register(ArcanaAttributeCell.self, forCellReuseIdentifier: "ArcanaAttributeCell")
        tableView.register(ArcanaSkillCell.self, forCellReuseIdentifier: "ArcanaSkillCell")
        tableView.register(ArcanaSkillAbilityDescCell.self, forCellReuseIdentifier: "ArcanaSkillAbilityDescCell")
        tableView.register(ArcanaChainStoryCell.self, forCellReuseIdentifier: "ArcanaChainStoryCell")
        tableView.register(ArcanaViewEditsCell.self, forCellReuseIdentifier: "ArcanaViewEditsCell")
        
        return tableView
    }()

    init(arcana: Arcana) {
        self.arcana = arcana
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ArcanaPeekPreview: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
