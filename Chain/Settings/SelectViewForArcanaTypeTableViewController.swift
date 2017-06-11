//
//  SelecttViewForArcanaTypeTableViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/29/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

enum SelectedArcanaView: Int {
    case search
    case tavern
    case favorites
    case all
}

class SelectViewForArcanaTypeViewController: UIViewController {

    fileprivate let viewTitles = ["홈", "주점", "즐겨찾기", "모두 적용"]

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsMultipleSelection = true
        tableView.isScrollEnabled = false
        
        tableView.register(ImageTypeCell.self, forCellReuseIdentifier: "SelectViewCell")
        
        return tableView
    }()
    
    lazy var completeButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        button.tintColor = .white
        button.backgroundColor = Color.lightGreen
        button.addTarget(self, action: #selector(completeView), for: .touchUpInside)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavBar()
    }
    
    func setupViews() {
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(completeButton)
        
        tableView.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 200)
        completeButton.anchor(top: tableView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
    }
    
    func setupNavBar() {
        
        navigationItem.title = "화면 선택"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))

    }
    
    @objc func completeView() {
        
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            var selectedArcanaViews = [SelectedArcanaView]()
            
            for indexPath in selectedIndexPaths {
                if let row = SelectedArcanaView(rawValue: indexPath.row) {
                    selectedArcanaViews.append(row)
                }
            }
            
            let vc = ArcanaViewTypePageViewController(selectedArcanaViews: selectedArcanaViews, showTip: false)
            navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }

}

extension SelectViewForArcanaTypeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectViewCell", for: indexPath) as! ImageTypeCell
        cell.titleLabel.text = viewTitles[indexPath.row]
        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath), let row = SelectedArcanaView(rawValue: indexPath.row) else { return }
        
        switch row {
        case .all:
            for cells in tableView.visibleCells {
                cells.accessoryType = .checkmark
                tableView.selectRow(at: tableView.indexPath(for: cells), animated: false, scrollPosition: .none)
            }
        default:
            cell.accessoryType = .checkmark
            var selectedAll = true
            for (index, cells) in tableView.visibleCells.enumerated() {
                if index != 3 {
                    if !cells.isSelected {
                        selectedAll = false
                    }
                }
                
            }
            if selectedAll {
                let indexPath = IndexPath(row: 3, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .checkmark
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath), let row = SelectedArcanaView(rawValue: indexPath.row) else { return }
        
        switch row {
        case .all:
            for cells in tableView.visibleCells {
                cells.accessoryType = .none
                if let indexPath = tableView.indexPath(for: cells) {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
        default:
            cell.accessoryType = .none
            let indexPath = IndexPath(row: 3, section: 0)
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }
    }
}
