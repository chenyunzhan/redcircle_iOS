//
//  ChatController.swift
//  redcircle
//
//  Created by zhan on 16/11/17.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SKPhotoBrowser


class ChatController: RCConversationViewController, SKPhotoBrowserDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.notifyUpdateUnreadMessageCount()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func notifyUpdateUnreadMessageCount() {
        super.notifyUpdateUnreadMessageCount()
        UIApplication.shared.applicationIconBadgeNumber = Int(RCIMClient.shared().getTotalUnreadCount())
        
        
        //需要主线程执行的代码
        let count = RCIMClient.shared().getTotalUnreadCount()
        
        
        DispatchQueue.main.async(execute: {
            if (count > 0) {
                self.navigationController?.tabBarItem.badgeValue = String(count)
                UIApplication.shared.applicationIconBadgeNumber = Int(count)
            } else {
                self.navigationController?.tabBarItem.badgeValue = nil
                UIApplication.shared.applicationIconBadgeNumber = 0
                
            }
        })
    }
    
    
    override func didTapCellPortrait(_ userId: String!) {
        super.didTapCellPortrait(userId)
        // add SKPhoto Array from UIImage
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + userId + "&type=original")
        images.append(photo)
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        browser.delegate = self
        present(browser, animated: true, completion: {})
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
