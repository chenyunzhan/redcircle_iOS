//
//  BookController.swift
//  redcircle
//
//  Created by zhan on 16/11/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class BookController: UITableViewController {
    
    var tableData: [Any] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "朋友"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加朋友", style: .done, target: self, action: #selector(BookController.addRootFriend));
        self.tableView.register(BookTableViewCell.classForCoder(), forCellReuseIdentifier: BookTableViewCell.cellID())
        
        
        let userDic = UserDefaults.standard.object(forKey: "USER_INFO") as! NSDictionary
        let mePhone = userDic["mePhone"] as! String
        
        
        Alamofire.request(AppDelegate.baseURLString + "/getFriends", method: .get, parameters: ["mePhone": mePhone]).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let JSONObject = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [Any],
                    let tableData = JSONObject {
                    self.tableData = tableData
                    self.tableView.reloadData()
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
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friends = self.tableData[section] as! NSDictionary
        let ffriend = friends["ffriend"] as! [NSDictionary]
        return ffriend.count
    }
    
    
    
    func addRootFriend() -> Void {
        let addFriendController = AddFriendController()
        addFriendController.hidesBottomBarWhenPushed = true
        addFriendController.initWithClosure(closure: someFunctionThatTakesAClosure)
        self.navigationController?.pushViewController(addFriendController, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID(), for: indexPath) as! BookTableViewCell
        let friends = self.tableData[indexPath.section] as! NSDictionary
        let ffriend = friends["ffriend"] as! [NSDictionary]
        let friend = ffriend[indexPath.row]
        cell.cellForModel(model: friend)
        return cell
    }
    
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let friends = self.tableData[section] as! NSDictionary
        let friend = friends["friend"] as! NSDictionary
        var name = friend["name"] as! String
        if name == "" {
            name = friend["friendPhone"] as! String
        }
        name = name + "的朋友圈"
        return name
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friends = self.tableData[indexPath.section] as! NSDictionary
        let ffriend = friends["ffriend"] as! [NSDictionary]
        let directFriend = friends["friend"] as! NSDictionary
        let friend = ffriend[indexPath.row]
        
        
        
        let userDetail = UserDetailController(style: .grouped)
        userDetail.friendPhone = friend["mePhone"] as? String
        userDetail.mePhone = directFriend["friendPhone"] as? String
        userDetail.hidesBottomBarWhenPushed = true
        
        
        let userDic = UserDefaults.standard.dictionary(forKey: "USER_INFO")
        if(directFriend["friendPhone"] as! String == userDic!["mePhone"] as! String) {
            if ((friend["recommendLanguage"] as! String).characters.count > 0) {
                self.navigationController?.pushViewController(userDetail, animated: true)
            } else {
                let modifyRelation = ModifyRelationController()
                modifyRelation.friendPhone = friend["mePhone"] as? String
                modifyRelation.mePhone = directFriend["friendPhone"] as? String
                modifyRelation.initWithClosure(closure: someFunctionThatTakesAClosure)
                modifyRelation.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(modifyRelation, animated: true)
                
            }
        } else {
            self.navigationController?.pushViewController(userDetail, animated: true)
        }
    }
    
    
    func someFunctionThatTakesAClosure(string:String) -> Void {
        self.viewDidLoad()
    }

}
