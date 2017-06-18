//
//  FirebaseService.swift
//  Chain
//
//  Created by Jitae Kim on 10/20/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    
    static let dataRequest = FirebaseService()
    
    private var FIREBASE_REF = Database.database().reference()
    private var ARCANA_REF = Database.database().reference().child("arcana")

    private var STORAGE_REF = Storage.storage().reference()
    
    func incrementCount(ref: DatabaseReference) {
        
        ref.runTransactionBlock({ data -> TransactionResult in
            
            if let chatCount = data.value as? Int {
                data.value = chatCount + 1
            }
            return TransactionResult.success(withValue: data)
            
        })
        
    }
    
    func incrementLikes(uid: String, increment: Bool) {
        let ref = ARCANA_REF.child("\(uid)/numberOfLikes")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            guard let base = snapshot.value as? Int else {
                return
            }
            
            if increment {
                ref.setValue(base+1)
            }
            else if base > 0 {
                   ref.setValue(base-1)
            }
            
            
            
        })
    }
    
    func uploadArcanaImage(arcanaID: String, image: UIImage, imageType: ImageType, completion: @escaping (Bool) -> ()) {
        
        guard let data = UIImageJPEGRepresentation(image, 1) else {
            completion(false)
            return
        }
        // upload to firebase storage.
        // start activity indicator
        let arcanaImageRef = STORAGE_REF.child("image/arcana").child(arcanaID).child("\(imageType).jpg")
        arcanaImageRef.putData(NSData(data: data) as Data, metadata: nil) { metadata, error in
            if (error != nil) {
                print("ERROR OCCURED WHILE UPLOADING \(imageType)")
                completion(false)
            } else {
                print("UPLOADED \(imageType) FOR \(arcanaID)")
                completion(true)
            }
        }
        
    }
    
}
