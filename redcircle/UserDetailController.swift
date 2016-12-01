//
//  UserDetailController.swift
//  redcircle
//
//  Created by zhan on 16/11/8.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton
import Alamofire


class UserDetailController: UITableViewController {

    var mePhone: String?
    var friendPhone: String?
    var userDic: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详细资料";
        let footerView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 150))
        footerView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = footerView
        
        
        
        
        let dialMobileButton = FlatButton(frame: CGRect(x: 20,y: 20,width: footerView.frame.size.width-40,height: 48))
        dialMobileButton.color = UIColor.red
        dialMobileButton.highlightedColor = UIColor.orange
        dialMobileButton.cornerRadius = 5
        
        let sendMessageButton = FlatButton(frame: CGRect(x: 20,y: 88,width: footerView.frame.size.width-40,height: 48))
        sendMessageButton.color = UIColor.red
        sendMessageButton.highlightedColor = UIColor.orange
        sendMessageButton.cornerRadius = 5
        
        
        dialMobileButton.setTitle("打电话", for: .normal)
        sendMessageButton.setTitle("发信息", for: .normal)
        
        
        dialMobileButton.addTarget(self, action: #selector(UserDetailController.dialMobileAction), for: .touchUpInside)
        
        sendMessageButton.addTarget(self, action: #selector(UserDetailController.sendMessageAction), for: .touchUpInside)
        
        footerView.addSubview(dialMobileButton)
        footerView.addSubview(sendMessageButton)
        
        
        
        let parameters = [
            "mePhone": mePhone!,
            "friendPhone": friendPhone!
        ]
        
        
        Alamofire.request(AppDelegate.baseURLString + "/userDetail", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                let userDic = response.result.value as? NSDictionary
                self.userDic = userDic
                self.tableView.reloadData()
                
                
                
                if (((self.userDic!["me_phone"] as! String).isEqual(NSNull()))) {
                    
                    self.tableView.tableFooterView?.isHidden = true
                    let alertController = UIAlertController(title: "提示", message: "该用户没有被激活", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
            case .failure(let error):
                print(error)
                let alertController = UIAlertController(title: "提示", message: response.result.error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func dialMobileAction () {
        if (self.userDic != nil) {
            let phoneNumber = self.userDic!["me_phone"] as! String
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: "tel:" + phoneNumber)! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: "tel:" + phoneNumber)! as URL)
            }
        }
    }
    
    
    
    
    func sendMessageAction () {
        //新建一个聊天会话View Controller对象
        let chat = ChatController()
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = self.userDic!["me_phone"] as! String
        //设置聊天会话界面要显示的标题
        if self.userDic!["name"] as! String != "" {
            chat.title = self.userDic!["name"] as? String
        } else {
            chat.title = self.userDic!["me_phone"] as? String
        }
        //显示聊天会话界面
        chat.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chat, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let photoImageView = UIImageView()
        let nameLabel = UILabel()
        let sexLabel = UILabel()
        let phoneLabel = UILabel()
        
        if indexPath.section == 0 {
            
            cell.contentView.addSubview(photoImageView)
            cell.contentView.addSubview(nameLabel)
            cell.contentView.addSubview(sexLabel)
            cell.contentView.addSubview(phoneLabel)
            
            photoImageView.snp.makeConstraints({ (make) in
                make.leading.equalTo(20)
                make.top.equalTo(8)
                make.bottom.equalTo(-8)
                make.width.equalTo(80)
            })
            
            nameLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(photoImageView.snp.right).offset(8)
                make.top.equalTo(8)
            })
            
            sexLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(photoImageView.snp.right).offset(8)
                make.centerY.equalTo(cell.contentView)
            })
            
            phoneLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(photoImageView.snp.right).offset(8)
                make.bottom.equalTo(-8)
            })
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        
        if (self.userDic != nil && !((self.userDic!["me_phone"] as! String).isEqual(NSNull()))) {
            if(indexPath.section == 0) {
                
                let imageUrl = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + (self.userDic!["me_phone"] as! String + "&type=thumbnail")
                
                
                Alamofire.request(imageUrl).responseData { response in
                    if let data = response.result.value {
                        let image = UIImage(data: data)
                        photoImageView.image = image

                    }
                }
                
                nameLabel.text = self.userDic!["name"] as? String
                sexLabel.text = self.userDic!["sex"] as? String
                phoneLabel.text = self.userDic!["me_phone"] as? String
            } else if(indexPath.section == 1) {
                
                cell.imageView?.image = UIImage.fontAwesomeIcon(name: .photo, textColor: UIColor.lightGray, size: CGSize(width: 20, height: 20))
                cell.textLabel?.text = "查看相册"
            } else if(indexPath.section == 2) {
                cell.imageView?.image = UIImage.fontAwesomeIcon(name: .heart, textColor: UIColor.lightGray, size: CGSize(width: 20, height: 20))
                cell.textLabel?.text = self.userDic!["recommend_language"] as? String
            }
        }
        
        
        
        return cell

    }

    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 96
        }
        return 44
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let modifyRelation = ModifyRelationController()
            modifyRelation.friendPhone = friendPhone
            modifyRelation.mePhone = mePhone
            modifyRelation.initWithClosure(closure: someFunctionThatTakesAClosure)
            modifyRelation.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(modifyRelation, animated: true)
        } else if indexPath.section == 1 {
            let meCircle = MeCircleController()
            meCircle.circleLevel = "0"
            meCircle.mePhone = friendPhone
            meCircle.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(meCircle, animated: true)
        }
    }
    
    
    func someFunctionThatTakesAClosure(string:String) -> Void {
        self.viewDidLoad()
    }


}
