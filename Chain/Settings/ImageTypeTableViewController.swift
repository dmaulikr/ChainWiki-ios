//
//  ImageTypeTableViewController.swift
//  Chain
//
//  Created by Jitae Kim on 3/28/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class ImageTypeTableViewController: UITableViewController {

    private enum Row: Int {
        case list
        case main
        case profile
        case mainGrid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
    }
    
    func setupTableView() {
        
        tableView.register(ProfileImageCell.self, forCellReuseIdentifier: "ProfileImageCell")
        tableView.register(MainImageCell.self, forCellReuseIdentifier: "MainImageCell")
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.estimatedRowHeight = 100
    }

    func setupNavBar() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "보기 설정"
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch row {
            
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell

            cell.arcanaImageView.image = #imageLiteral(resourceName: "sampleProfile")
            cell.titleLabel.text = "프로필 + 정보 보기 (기본)"
            
            return cell
        case .main:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainImageCell") as! MainImageCell
            
            cell.arcanaImageView.image = #imageLiteral(resourceName: "sampleMain")
            cell.titleLabel.text = "메인 사진 + 정보 보기"
            
            return cell
            
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell
            
            cell.arcanaImageView.image = #imageLiteral(resourceName: "sampleProfile")
            cell.titleLabel.text = "프로필 사진만 보기"
            
            return cell
        case .mainGrid:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell
            
            cell.arcanaImageView.image = #imageLiteral(resourceName: "sampleMain")
            cell.titleLabel.text = "메인 사진만 보기"
            
            return cell
            
        }
        

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = Row(rawValue: indexPath.row) else { return }
        
        switch row {
        case .list:
            defaults.setArcanaView(value: "list")
        case .main:
            defaults.setArcanaView(value: "main")
        case .profile:
            defaults.setArcanaView(value: "profile")
        case .mainGrid:
            defaults.setArcanaView(value: "mainGrid")
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
