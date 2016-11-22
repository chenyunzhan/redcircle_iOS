//
//  MessageController.swift
//  redcircle
//
//  Created by zhan on 16/11/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire




class MessageController: RCConversationListViewController, RCIMUserInfoDataSource{



    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "消息"
        RCIM.shared().userInfoDataSource = self
        
        let emptyLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        emptyLabel.text = "请在朋友页面发起会话"
        emptyLabel.textColor = UIColor.lightGray
        self.emptyConversationView = emptyLabel
        
        
        emptyLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-64)
        }

        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,
                                          RCConversationType.ConversationType_DISCUSSION.rawValue,
                                          RCConversationType.ConversationType_CHATROOM.rawValue,
                                          RCConversationType.ConversationType_GROUP.rawValue,
                                          RCConversationType.ConversationType_APPSERVICE.rawValue,
                                          RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
                                            RCConversationType.ConversationType_GROUP.rawValue])
        
        
        let userDic = UserDefaults.standard.dictionary(forKey: "USER_INFO")
        let mePhone = userDic!["mePhone"] as! NSString
        var name = userDic!["name"] as! NSString
        if (name == "") {
            name = mePhone
        }
        
        
        let token = UserDefaults.standard.string(forKey: "RC_TOKEN")
        
        
        if (token == nil) {
            
            Alamofire.request(AppDelegate.baseURLString + "/getRongCloudToken", method: .get, parameters: ["mePhone": mePhone, "name": name]).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    if let JSONObject = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String: Any],
                        let token = (JSONObject?["result"] as! [String: Any])["token"] as? String {
                        UserDefaults.standard.set(token, forKey: "RC_TOKEN")
                        
                        
                        RCIM.shared().connect(withToken: token, success: { (userId) -> Void in
                            print("登陆成功。当前登录的用户ID：\(userId)")
                            }, error: { (status) -> Void in
                                print("登陆的错误码为:\(status.rawValue)")
                            }, tokenIncorrect: {
                                //token过期或者不正确。
                                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                print("token错误")
                        })
                    }
                    

                case .failure(let error):
                    print(error)
                    let alertController = UIAlertController(title: "提示", message: response.result.error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        } else {
            RCIM.shared().connect(withToken: token, success: { (userId) -> Void in
                print("登陆成功。当前登录的用户ID：\(userId)")
                }, error: { (status) -> Void in
                    print("登陆的错误码为:\(status.rawValue)")
                }, tokenIncorrect: {
                    //token过期或者不正确。
                    //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                    //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                    print("token错误")
            })
        }
        
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*!
     获取用户信息
     
     @param userId      用户ID
     @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
     
     @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
     在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
     */
    public func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        
        let x = arc4random() % 100
//        let parameters = [
//            "friendArrayMap": self.friendArray as AnyObject,
//            "meInfo": self.meInfo as AnyObject
//        ]
        
        let parameters = [
            "mePhone": userId as String,
            "random":String(x)
        ]
        
        
        
        
        Alamofire.request(AppDelegate.baseURLString + "/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success:
                let userDic = response.result.value as? NSDictionary
                
                if(userDic!["name"] != nil) {
                    if (userDic!["name"] as! String == "") {
                        completion?(RCUserInfo.init(userId: userId, name: userId, portrait: AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + userId + "&type=thumbnail"))
                    } else {
                        completion?(RCUserInfo.init(userId: userId, name: userDic!["name"] as? String, portrait: AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + userId + "&type=thumbnail"))
                    }
                } else {
                    completion?(RCUserInfo.init(userId: userId, name: userId, portrait: nil))
                }
            case .failure(let error):
                print(error)
                completion?(RCUserInfo.init(userId: userId, name: userId, portrait: nil))
            }
            
        }
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
