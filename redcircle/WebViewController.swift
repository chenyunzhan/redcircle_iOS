
//
//  WebViewController.swift
//  redcircle
//
//  Created by zhan on 16/11/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    override func viewDidLoad() {
        
        self.title = "用户协议";
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(WebViewController.cancelAction))
        
        
        let webView = UIWebView(frame: self.view.frame)
        webView.loadRequest(NSURLRequest(url: (NSURL(string: AppDelegate.baseURLString + "/agreement.html"))! as URL) as URLRequest)
        
        
        self.view.addSubview(webView)
        
    }
    
    
    func cancelAction() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
