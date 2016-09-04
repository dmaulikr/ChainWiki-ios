//
//  ReverseImageSearch.swift
//  Chain
//
//  Created by Jitae Kim on 9/3/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import WebKit

class ReverseImageSearch: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView : WKWebView!
    
    //var imagePicker = UIImagePickerController()
//    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//            // TODO: Organize conditional code.
//            print("PICKED IMAGE")
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
    
    func clickImage() {
        self.webView.evaluateJavaScript("document.getElementById('qbi').click()")  { (result, error) in
            
        }
    }
    
    func clickTab(timer : NSTimer) {
        self.webView.evaluateJavaScript("document.getElementsByClassName('qbtbha qbtbtxt qbclr')[0].click()") {(result, error) in
        }
    }
    
    func clickUpload(timer : NSTimer) {
        self.webView.evaluateJavaScript("document.getElementById('qbfile').click()") {(result, error) in
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let href = webView.stringByEvaluatingJavaScriptFromString("window.location.href")
        print("window.location.href  = \(href)")
        
        let doc = webView.stringByEvaluatingJavaScriptFromString("document")
        print("document = \(doc)")
    }
    
    override func loadView() {
        super.loadView()
        
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: config)
        webView!.UIDelegate = self
        webView!.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36"
        self.view.addSubview(webView)
        //load URL here

        // qbi
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "https://images.google.com/")!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)

//        let secondTimer : NSTimer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(ReverseImageSearch.clickTab(_:)), userInfo: nil, repeats: false)
//        let thirdTimer : NSTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(ReverseImageSearch.clickUpload(_:)), userInfo: nil, repeats: false)
        
        
        addObserver(webView, forKeyPath: "loading", options: .New, context: nil)

            

        
        // Do any additional setup after loading the view.
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let _ = object as? WKWebView else { return }
        guard let keyPath = keyPath else { return }
        guard let change = change else { return }
        switch keyPath {
        case "loading":
            if let val = change[NSKeyValueChangeNewKey] as? Bool {
                if val {
                } else {
                    print(self.webView.loading)
                    //do something!
                }
            }
        default:break
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "loading")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("WebView content loaded.")

        if webView.URL == NSURL(string: "https://images.google.com/")! {
            clickImage()
        }
        
        else if webView.URL == NSURL(string: "https://www.google.com/*") {
            print("ODOIDWODIOWDI")
        }
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
