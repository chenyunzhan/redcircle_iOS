

//
//  BaseViewController.swift
//  redcircle
//
//  Created by zhan on 16/11/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    
    var loadingView: UIAlertController?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //create an alert controller
        let pending = UIAlertController(title: "请等待...\n\n\n", message: nil, preferredStyle: .alert)
        
        self.loadingView = pending
        
        
        //create an activity indicator
        let indicator = UIActivityIndicatorView()
        indicator.frame.size = CGSize(width: 30, height: 30)
        indicator.center = CGPoint(x:150, y: 80)
//        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.color = UIColor.black

        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        pending.view.frame.size = CGSize(width: 500, height: 250)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        

        let height:NSLayoutConstraint = NSLayoutConstraint(item: pending.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 130)
        let width:NSLayoutConstraint = NSLayoutConstraint(item: pending.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)

        
        pending.view.addConstraint(height);
        pending.view.addConstraint(width);


    }


    

    
    func startLoadingView() -> Void {
        self.present(self.loadingView!, animated: true, completion: nil)
    }
    
    
    
    func stopLoadingView() -> Void {
        self.dismiss(animated: true)
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
