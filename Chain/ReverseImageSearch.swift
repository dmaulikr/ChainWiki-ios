//
//  ReverseImageSearch.swift
//  Chain
//
//  Created by Jitae Kim on 9/3/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import WebKit

class ReverseImageSearch: UIViewController, WKUIDelegate {

    var webView : WKWebView!

//    var imagePicker = UIImagePickerController()
//    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//            // TODO: Organize conditional code.
//       
//            let uuid = NSUUID()
//            // Data in memory
//            let data: NSData = UIImageJPEGRepresentation(image, 0.3)!
//            
//            // Upload to firebase, then use the url in storage to reverse search. Then delete this image from firebase storage.
//            
//            let uploadRef = STORAGE_REF.child("user/\(uuid.UUIDString)/image.jpg")
//            let uploadTask = uploadRef.putData(data, metadata: nil) { metadata, error in
//                if (error != nil) {
//                    print("ERROR OCCURED WHILE UPLOADING IMAGE")
//                    // Uh-oh, an error occurred!
//                } else {
//                    // Metadata contains file metadata such as size, content-type, and download URL.
//                    print("UPLOADED IMAGE.")
//                    let downloadURL = metadata!.downloadURL
//                    // Pass downloadURL to google reverse image search
//
//                }
//            }
//        })
//        
//    }

//    @IBAction func uploadImage(sender: AnyObject) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
//            print("Button capture")
//            //imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
//            imagePicker.allowsEditing = false
//            
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: config)
        self.webView!.UIDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36"
        //load URL here
        let url = NSURL(string: "https://images.google.com/")!
        webView.loadRequest(NSMutableURLRequest(URL: url))
        self.view.addSubview(webView)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
