//
//  UploadArcanaViewController.swift
//  ArcanaDatabase
//
//  Created by Jitae Kim on 6/12/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class UploadArcanaButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tintColor = .white
        backgroundColor = Color.lightGreen
        titleLabel?.font = APPLEGOTHIC_17
    }
}

class UploadArcanaViewController: UIViewController {
    
    lazy var arcanaURLLabel: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "아르카나 주소"
        return textField
    }()
    
    lazy var arcanaProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color.gray247
        if #available(iOS 11.0, *) {
            customEnableDropping(on: imageView, dropInteractionDelegate: self)
        }
        return imageView
    }()
    
    lazy var arcanaMainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color.gray247
        if #available(iOS 11.0, *) {
            customEnableDropping(on: imageView, dropInteractionDelegate: self)
        }
        return imageView
    }()
    
    lazy var updateImageButton: UploadArcanaButton = {
        let button = UploadArcanaButton(type: .system)
        button.setTitle("이미지 업데이트", for: .normal)
        return button
    }()
    
    lazy var uploadArcanaButton: UploadArcanaButton = {
        let button = UploadArcanaButton(type: .system)
        button.setTitle("아르카나 업로드", for: .normal)
        return button
    }()
    
    let animatingView = AnimateUploadView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        navigationItem.title = "아르카나 업로드"
        view.backgroundColor = .white
        
        view.addSubview(arcanaURLLabel)
        view.addSubview(arcanaProfileImageView)
        view.addSubview(arcanaMainImageView)
        view.addSubview(updateImageButton)
        view.addSubview(uploadArcanaButton)
        
        arcanaURLLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 20, trailingConstant: 20, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        
        arcanaProfileImageView.anchor(top: arcanaURLLabel.bottomAnchor, leading: arcanaURLLabel.leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 75, heightConstant: 75)
        
        arcanaMainImageView.anchor(top: arcanaProfileImageView.bottomAnchor, leading: arcanaURLLabel.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 10, leadingConstant: 0, trailingConstant: 20, bottomConstant: 20, widthConstant: 0, heightConstant: 400)
        
        let border = UIView()
        border.backgroundColor = .white
        view.addSubview(border)
        
        let uploadStackView = UIStackView(arrangedSubviews: [updateImageButton, border, uploadArcanaButton])
        uploadStackView.axis = .horizontal
        uploadStackView.alignment = .fill
        uploadStackView.distribution = .fillProportionally
        
        border.anchor(top: uploadStackView.topAnchor, leading: nil, trailing: nil, bottom: uploadStackView.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 1, heightConstant: 0)
        
        view.addSubview(uploadStackView)
        uploadStackView.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 10, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 60)
        
    }
    
}
