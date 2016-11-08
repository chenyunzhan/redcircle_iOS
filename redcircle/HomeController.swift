//
//  HomeController.swift
//  redcircle
//
//  Created by zhan on 16/11/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import FontAwesome_swift


class HomeController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let messageController = MessageController()
        let meController = MeController(style: .grouped)
        let bookController = BookController(style: .grouped)
        
        
        
        
        
        let messageNavController = UINavigationController(rootViewController: messageController)
        let meNavController = UINavigationController(rootViewController: meController)
        let bookNavController = UINavigationController(rootViewController: bookController)
        
        
        
        
//        logoImageView.image = UIImage.fontAwesomeIcon(name: .circleO, textColor: UIColor.red, size: CGSize(width: 200, height: 200))

        messageController.tabBarItem = UITabBarItem(title: "消息", image: UIImage.fontAwesomeIcon(name: .comment, textColor: UIColor.black, size: CGSize(width: 30, height: 30)), tag: 100)
        bookController.tabBarItem = UITabBarItem(title: "朋友", image: UIImage.fontAwesomeIcon(name: .users, textColor: UIColor.black, size: CGSize(width: 30, height: 30)), tag: 101)
        meController.tabBarItem = UITabBarItem(title: "我的", image: UIImage.fontAwesomeIcon(name: .user, textColor: UIColor.black, size: CGSize(width: 30, height: 30)), tag: 102)
        
        
        self.viewControllers = [messageNavController,bookNavController,meNavController]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
