//
//  ArcanaDetail+TableView.swift
//  Chain
//
//  Created by Jitae Kim on 6/18/17.
//  Copyright © 2017 Jitae Kim. All rights reserved.
//

import UIKit

extension ArcanaDetail: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case image
        case attribute
        case skill
        case ability
        case kizuna
        case chainStory
        case wikiJP
        case edit
    }
    
    private enum AttributeRow: Int {
        case name
        case rarityCost
        case classWeapon
        case affiliationTavern
    }
    
    private enum SkillRow: Int {
        case skill1
        case skill2
        case skill3
    }
    
    private enum AbilityRow: Int {
        case ability1
        case ability2
        case partyAbility
    }
    
    private enum ChainStoryRow: Int {
        case chainStory
        case chainStone
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .image:
            return 1
        case .attribute:
            return 4
        case .skill:
            
            // Returning 2 * skillCount for description.
            switch arcana.getSkillCount() {
            case "1":
                return 1
            case "2":
                return 2
            case "3":
                return 3
            default:
                return 1
            }
            
        case .ability:
            
            if let _ = arcana.getPartyAbility() {
                return 3
            }
            else if let _ = arcana.getAbilityName3() {  // 리제 롯데
                return 3
            }
            else if let _ = arcana.getAbilityName2() {  // has 2 abilities
                return 2
            }
            else if let _ = arcana.getAbilityName1() {  // has only 1 ability
                return 1
            }
            else {
                return 0
            }
            
        case .kizuna:
            return 1
            
        case .chainStory:
            var count = 0
            if let _ = arcana.getChainStory() {
                count += 1
            }
            if let _ = arcana.getChainStone() {
                count += 1
            }
            
            return count
            
        case .wikiJP:
            return 1
        case .edit:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .image:
            return min(tableView.frame.width * 1.5, 500)
        case .attribute:
            return 90
        default:
            return 90
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .image:
            return min(tableView.frame.width * 1.5, 650)
//            return 450
        case .attribute:
            return 90
        default:
            return UITableViewAutomaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView.numberOfRows(inSection: section) != 0 {
            guard let section = Section(rawValue: section) else { return 0 }
            
            switch section {
            case .image:
                return CGFloat.leastNonzeroMagnitude
            default:
                return 20
            }
        }
        
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        case .image:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaMainImageViewWrapperCell") as! ArcanaMainImageViewWrapperCell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaImageCell") as! ArcanaImageCell
            cell.selectionStyle = .none
            
//            if UIDevice.current.userInterfaceIdiom == .phone {
            cell.arcanaMainImageView.arcanaImageView.addGestureRecognizer(tapImageGesture)
//                cell.arcanaImageView.addGestureRecognizer(tapImageGesture)
//            if let arcanaSection = arcanaSection {
//                cell.arcanaImageView.heroID = arcana.getUID() + "\(arcanaSection.rawValue)"
//            }
//            }
//            if #available(iOS 11.0, *) {
//                customEnableDropping(on: cell.arcanaImage, dropInteractionDelegate: self)
//            }
            cell.arcanaMainImageView.arcanaImageView.loadArcanaImage(arcanaID: arcana.getUID(), urlString: arcana.imageURL, completion: { (arcanaID, arcanaImage) in
                DispatchQueue.main.async {
                    cell.arcanaMainImageView.imageLoaded = true
                    cell.arcanaMainImageView.arcanaImageView.animateImage(arcanaImage)
                }
            })
            return cell
            
        case .attribute:
            
            guard let row = AttributeRow(rawValue: indexPath.row) else { return UITableViewCell() }
            
            switch row {
                
            case .name:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaNameCell", for: indexPath) as! ArcanaNameCell
                cell.selectionStyle = .none
                cell.arcanaImageView.loadArcanaImage(arcanaID: arcana.getUID(), urlString: arcana.iconURL, completion: { (arcanaID, arcanaImage) in
                    DispatchQueue.main.async {
                        cell.arcanaImageView.animateImage(arcanaImage)
                    }
                })
                
                if let nnKR = arcana.getNicknameKR() {
                    cell.arcanaNameKRLabel.text = nnKR + " " + arcana.getNameKR()
                }
                else {
                    cell.arcanaNameKRLabel.text = arcana.getNameKR()
                }
                
                if let nnJP = arcana.getNicknameJP() {
                    cell.arcanaNameJPLabel.text = nnJP + arcana.getNameJP()
                }
                else {
                    cell.arcanaNameJPLabel.text = arcana.getNameJP()
                }
                
                return cell
            case .rarityCost:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaBaseInfoCell", for: indexPath) as! ArcanaBaseInfoCell
                cell.selectionStyle = .none
                cell.arcanaClassImageView.isHidden = true
                
                cell.attributeKeyFirstLabel.text = "레어"
                cell.attributeDescFirstLabel.text = getRarityLong(arcana.getRarity())
                
                cell.attributeKeySecondLabel.text = "코스트"
                cell.attributeDescSecondLabel.text = arcana.getCost()
                
                return cell
                
            case .classWeapon:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaBaseInfoCell", for: indexPath) as! ArcanaBaseInfoCell
                cell.selectionStyle = .none
                
                cell.arcanaClassImageView.isHidden = false
                
                switch arcana.getGroup() {
                case "전사":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "warrior")
                case "기사":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "knight")
                case "궁수":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "archer")
                case "법사":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "magician")
                case "승려":
                    cell.arcanaClassImageView.image = #imageLiteral(resourceName: "healer")
                default:
                    break
                }
                
                cell.attributeKeyFirstLabel.text = "직업"
                cell.attributeDescFirstLabel.text = arcana.getGroup()
                
                cell.attributeKeySecondLabel.text = "무기"
                cell.attributeDescSecondLabel.text = arcana.getWeapon()
                
                return cell
                
            case .affiliationTavern:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaBaseInfoCell", for: indexPath) as! ArcanaBaseInfoCell
                cell.selectionStyle = .none
                cell.arcanaClassImageView.isHidden = true
                
                cell.attributeKeyFirstLabel.text = "소속"
                cell.attributeDescFirstLabel.text = arcana.getAffiliation()
                
                cell.attributeKeySecondLabel.text = "출현 장소"
                cell.attributeDescSecondLabel.text = arcana.getTavern()
                
                return cell
            }
            
        case .skill:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillCell") as! ArcanaSkillCell
            
            guard let row = SkillRow(rawValue: indexPath.row) else { return cell }
            
            cell.selectionStyle = .none
            
            switch row {
                
            case .skill1:
                cell.skillNumberLabel.text = "스킬 1"
                cell.skillManaLabel.text = "\(arcana.getSkillMana1()) 마나"
                cell.skillDescLabel.text = arcana.getSkillDesc1()
            case .skill2:
                cell.skillNumberLabel.text = "스킬 2"
                let skillMana2 = arcana.getSkillMana2() ?? "1"
                cell.skillManaLabel.text = skillMana2 + " 마나"
                cell.skillDescLabel.text = arcana.getSkillDesc2()
            case .skill3:
                cell.skillNumberLabel.text = "스킬 3"
                let skillMana3 = arcana.getSkillMana3() ?? "1"
                cell.skillManaLabel.text = skillMana3 + " 마나"
                cell.skillDescLabel.text = arcana.getSkillDesc3()
            }
            
            cell.skillDescLabel.setLineHeight(lineHeight: 1.2)
            
            return cell
            
        case .ability:
            
            guard let row = AbilityRow(rawValue: indexPath.row) else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaAttributeCell") as! ArcanaAttributeCell
            cell.selectionStyle = .none
            
            switch row {
            case .ability1:
                cell.attributeKeyLabel.text = "어빌 1"
                cell.attributeValueLabel.text = arcana.getAbilityDesc1()
            case .ability2:
                cell.attributeKeyLabel.text = "어빌 2"
                cell.attributeValueLabel.text = arcana.getAbilityDesc2()
                
            case .partyAbility:
                if let _ = arcana.getPartyAbility() {
                    cell.attributeKeyLabel.text = "파티 어빌"
                    cell.attributeValueLabel.text = arcana.getPartyAbility()
                }
                else {
                    // 리제 롯데
                    cell.attributeKeyLabel.text = "어빌 3"
                    cell.attributeValueLabel.text = arcana.getAbilityDesc3()
                }
            }
            
            cell.attributeValueLabel.setLineHeight(lineHeight: 1.2)
            //            cell.attributeValueLabel.layoutIfNeeded()
            return cell
            
        case .kizuna:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaSkillCell") as! ArcanaSkillCell
            cell.selectionStyle = .none
            
            cell.skillNumberLabel.text = "인연"
            cell.skillManaLabel.text = "코스트 \(arcana.getKizunaCost())"
            cell.skillDescLabel.text = arcana.getKizunaDesc()
            
            cell.skillDescLabel.setLineHeight(lineHeight: 1.2)
            
            return cell
            
        case .chainStory:
            
            guard let row = ChainStoryRow(rawValue: indexPath.row) else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaAttributeCell") as! ArcanaAttributeCell
            cell.selectionStyle = .none
            
            switch row {
                
            case .chainStory:
                if let cStory = arcana.getChainStory() {
                    cell.attributeKeyLabel.text = "체인스토리"
                    cell.attributeValueLabel.text = cStory
                    return cell
                } else if let cStone = arcana.getChainStone() {
                    cell.attributeKeyLabel.text = "정령석 보상"
                    cell.attributeValueLabel.text = cStone
                }
                
            case .chainStone:
                if let cStone = arcana.getChainStone() {
                    cell.attributeKeyLabel.text = "정령석 보상"
                    cell.attributeValueLabel.text = cStone
                }
            }
            
            return cell
            
        case .wikiJP:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaViewEditsCell") as! ArcanaViewEditsCell
            cell.editLabel.text = "일첸 위키 가기"
            cell.arrow.image = #imageLiteral(resourceName: "go")
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        case .edit:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArcanaViewEditsCell") as! ArcanaViewEditsCell
            cell.editLabel.text = "편집 기록 보기"
            cell.arrow.image = #imageLiteral(resourceName: "go")
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .wikiJP:
            
            let baseURL = "https://xn--eckfza0gxcvmna6c.gamerch.com/"
            
            var arcanaURL = ""
            if let nicknameJP = arcana.getNicknameJP() {
                arcanaURL = nicknameJP + arcana.getNameJP()
            }
            else {
                arcanaURL = arcana.getNameJP()
            }
            guard let encodedURL = arcanaURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed), let url = URL(string: (baseURL + encodedURL)) else { return }
            let vc = LinkViewController(url: url)
//            navigationController?.isHeroEnabled = false
            navigationController?.pushViewController(vc, animated: true)
        case .edit:
            let vc = ArcanaEditList(arcanaID: arcana.getUID())
//            navigationController?.isHeroEnabled = false
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
        
    }
    
}
