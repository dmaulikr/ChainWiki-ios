//
//  ArcanaImageCell.swift
//  Chain
//
//  Created by Jitae Kim on 8/29/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AlamofireImage

class ArcanaImageCell: UITableViewCell {

//    @IBOutlet weak var arcanaImage: UIButton!
    @IBOutlet weak var arcanaImage: UIImageView!
    @IBOutlet weak var imageSpinner: NVActivityIndicatorView!
    
    @IBOutlet weak var heart: UIButton!
    @IBOutlet weak var favorite: UIButton!
    
    /*
    var arcanaUID: String?
    
    var imageTapped = false
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        if imageTapped == false {
            // enlarge image
            if let arcanaUID = arcanaUID {
                if let imageView = IMAGECACHE.image(withIdentifier: "\(arcanaUID)/main.jpg") {
                    
                    let newImageView = UIImageView(image: imageView)
                    newImageView.frame = UIScreen.main.bounds
                    newImageView.backgroundColor = .black
                    newImageView.contentMode = .scaleAspectFit
                    newImageView.isUserInteractionEnabled = true
                    sender.view?.window?.addSubview(newImageView)
                    
                    addGestures(newImageView)
                    imageTapped = true
                }
            }

        }
        
    }
//    (target: self, action: #selector(Home.dismissFilter(_:)))
    func addGestures(_ sender: AnyObject) {
        
        let closeImage = UITapGestureRecognizer(target: self, action: #selector(self.dismissImage(_:)))
        sender.addGestureRecognizer(closeImage)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        swipeDown.direction = .down
        sender.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        swipeUp.direction = .up
        sender.addGestureRecognizer(swipeUp)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        swipeRight.direction = .right
        sender.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(dismissImage(_:)))
        swipeLeft.direction = .left
        sender.addGestureRecognizer(swipeLeft)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(saveImage(_:)))
        sender.addGestureRecognizer(longPress)
    }
    
    func dismissImage(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.2, animations: {
            sender.view?.alpha = 0
        }) { _ in
            sender.view?.removeFromSuperview()
        }
        imageTapped = false
    }
    
    func saveImage(_ sender: AnyObject) {

        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = salmonColor
        
        let save = UIAlertAction(title: "이미지 저장", style: .default, handler: { (action:UIAlertAction) in
            UIImageWriteToSavedPhotosAlbum(self.arcanaImage.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        })
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: { (action:UIAlertAction) in
        })
        
        alertController.addAction(save)
        alertController.addAction(cancel)

        
        

    }
    
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "저장 실패", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "확인", style: .default))
            if let vc = self.parentViewController {
                vc.present(ac, animated: true)
            }
            
        } else {
            let ac = UIAlertController(title: "저장 완료!", message: "", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "확인", style: .default))
            UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true, completion: nil)
            
            
        }
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
//        arcanaImage.addGestureRecognizer(tap)
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
