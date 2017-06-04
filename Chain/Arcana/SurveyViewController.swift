//
//  SurveyViewController.swift
//  Chain
//
//  Created by Jitae Kim on 6/2/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {

    let index: Int
    let desc: String
    weak var pageViewDelegate: SurveyPageViewController?
    var showAdditional = false
    
    let questionLabel: KRLabel = {
        let label = KRLabel()
        label.font = APPLEGOTHIC_17
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tag = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.estimatedRowHeight = 80
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(SurveyCell.self, forCellReuseIdentifier: "SurveyCell")
        
        return tableView
    }()
    
    fileprivate lazy var additionalTableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tag = 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.estimatedRowHeight = 80
        tableView.allowsMultipleSelection = true
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(SurveyCell.self, forCellReuseIdentifier: "SurveyCell")
        
        return tableView
    }()

    var pageControlTopConstraint: NSLayoutConstraint?
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = Color.lightGreen
        return pageControl
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("뒤로", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = APPLEGOTHIC_17
        button.backgroundColor = Color.lightGreen
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = APPLEGOTHIC_17
        button.backgroundColor = Color.lightGreen
        button.addTarget(self, action: #selector(showNext), for: .touchUpInside)
        return button
    }()
    
    init(index: Int, desc: String) {
        self.index = index
        self.desc = desc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func back() {
        guard index > 0, let pageVC = pageViewDelegate else { return }
        pageVC.setViewControllers([pageVC.viewControllerList[index-1]], direction: .reverse, animated: true, completion: nil)
    }
    
    func showNext() {
        guard index < 2, let pageVC = pageViewDelegate else { return }
        pageVC.setViewControllers([pageVC.viewControllerList[index+1]], direction: .forward, animated: true, completion: nil)
    }
    
    func setupViews() {
        
        pageControl.currentPage = index
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        view.addSubview(questionLabel)
        view.addSubview(tableView)
        
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        
        questionLabel.text = desc
        questionLabel.anchor(top: topLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 10, trailingConstant: 10, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        tableView.anchor(top: questionLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 20, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        pageControl.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        pageControlTopConstraint = pageControl.topAnchor.constraint(equalTo: tableView.bottomAnchor)
        pageControlTopConstraint?.isActive = true
        
        pageControl.anchorCenterXToSuperview()

        let border = UIView()
        border.backgroundColor = .white
        view.addSubview(border)
        
        let buttonStackView = UIStackView(arrangedSubviews: [backButton, border, nextButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        
        view.addSubview(buttonStackView)
        
        border.anchor(top: buttonStackView.topAnchor, leading: nil, trailing: nil, bottom: buttonStackView.bottomAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 1, heightConstant: 0)

        buttonStackView.anchor(top: pageControl.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: bottomLayoutGuide.topAnchor, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
    }

    func setupAdditionalTableView() {
        
        view.addSubview(additionalTableView)

        additionalTableView.anchor(top: tableView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        
        pageControlTopConstraint?.isActive = false
        pageControlTopConstraint = pageControl.topAnchor.constraint(equalTo: additionalTableView.bottomAnchor)
        pageControlTopConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
}

extension SurveyViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum TableView: Int {
        case base
        case additional
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let tv = TableView(rawValue: tableView.tag) else { return 0 }
        switch tv {
        case .base:
            return 2
        case .additional:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = TableView(rawValue: tableView.tag) else { return UITableViewCell() }
        
        switch section {
            
        case .base:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell", for: indexPath) as! SurveyCell
            cell.selectionStyle = .none

            switch index {
                
            case 0:
                
                switch indexPath.row {
                case 0:
                    cell.answerLabel.text = "보기 더 편하다."
                case 1:
                    cell.answerLabel.text = "불편하다."
                default:
                    break
                }
                
            case 1:
                
                switch indexPath.row {
                case 0:
                    cell.answerLabel.text = "지금이 좋다."
                case 1:
                    cell.answerLabel.text = "이전이 좋다."
                default:
                    break
                }
                
            default:
                break
            }
            
            return cell

        case .additional:
            
            let cell = additionalTableView.dequeueReusableCell(withIdentifier: "SurveyCell", for: indexPath) as! SurveyCell
            cell.selectionStyle = .none

            switch index {
                
            case 0:
                
                switch indexPath.row {
                case 0:
                    cell.answerLabel.text = "스와입을 안 쓰는 사람으로서 뒤로 갈 때 버튼 누를 수 없어서 불편하다."
                case 1:
                    cell.answerLabel.text = "아무 데나 누르면 창이 표시되거나 숨기는 게 불편하다."
                case 2:
                    cell.answerLabel.text = "글씨 색상 또는 간격 때문에 보기 불편하다."
                default:
                    break
                }
                
            default:
                break
            }
            
            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let tv = TableView(rawValue: tableView.tag) else { return }
        cell.accessoryType = .checkmark
        
        switch tv {
        case .base:
            if indexPath.row == 0 {
                if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
                    cell.accessoryType = .none
                    tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
                }
                
            }
            else if indexPath.row == 1 {
                setupAdditionalTableView()
            }
        case .additional:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let tv = TableView(rawValue: tableView.tag) else { return }
        cell.accessoryType = .none
        switch tv {
        case .base:
            if indexPath.row == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.additionalTableView.removeFromSuperview()
                    self.pageControlTopConstraint = self.pageControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor)
                    self.pageControlTopConstraint?.isActive = true
                })
            }
        case .additional:
            break

        }
    }
}
