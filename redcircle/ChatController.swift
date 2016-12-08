//
//  ChatController.swift
//  redcircle
//
//  Created by zhan on 16/11/17.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit

class ChatController: RCConversationViewController {

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
