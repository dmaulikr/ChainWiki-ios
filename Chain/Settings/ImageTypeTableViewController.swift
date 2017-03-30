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
        case profile
        case main
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
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch row {
            
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell") as! ProfileImageCell

            cell.arcanaImageView.image = #imageLiteral(resourceName: "sampleProfile")
            cell.titleLabel.text = "프로필 사진 보기"
            
            return cell
        case .main:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainImageCell") as! MainImageCell
            
            cell.arcanaImageView.image = #imageLiteral(resourceName: "sampleMain")
            cell.titleLabel.text = "메인 사진 보기"
            
            return cell
        }
        

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let row = Row(rawValue: indexPath.row) else { return }
        
        switch row {
        case .profile:
            defaults.setMainImage(value: false)
        case .main:
            defaults.setMainImage(value: true)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
