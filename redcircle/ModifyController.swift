//
//  ModifyController.swift
//  redcircle
//
//  Created by zhan on 16/12/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire


class ModifyController: UIViewController {

    var subTitle: String = ""
    var textField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改" + self.subTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "修改", style: UIBarButtonItemStyle.done, target: self, action: #selector(ModifyController.doModifyAction));
        
        self.view.backgroundColor = UIColor.white
        
        let textField = UITextField()
        textField.placeholder = "请输入新的" + self.subTitle
        self.textField = textField
        self.view.addSubview(textField)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.red
        self.view .addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(textField.snp.bottom)
            make.right.equalTo(textField)
            make.left.equalTo(textField)
            make.height.equalTo(1)
        }
        
        textField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(80)
            make.right.equalTo(self.view).offset(-20)
            make.left.equalTo(self.view).offset(20)
            make.height.equalTo(40)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func doModifyAction() {
        
        var userParam = "name"
        
        if self.subTitle == "性别" {
            userParam = "sex"
        }
        
        let userDic = UserDefaults.standard.object(forKey: "USER_INFO") as! NSDictionary
        let mePhone = userDic["mePhone"] as! String
        
        let parameters = [
            userParam : self.textField?.text as Any,
            "mePhone"   : mePhone 
        ]
        
        
        
        Alamofire.request(AppDelegate.baseURLString + "/modify", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            if response.result.isSuccess {
                
            }
            
            switch response.result {
            case .success:
                let parameters = [
                    "mePhone": mePhone
                ]
                
                
                Alamofire.request(AppDelegate.baseURLString + "/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
                    
                    switch response.result {
                    case .success:
                        let userDic = response.result.value as? NSDictionary
                        UserDefaults.standard.set(userDic, forKey: "USER_INFO")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "USER_INFO_CHANGE"), object: self)
                        _ = self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print(error)
                    }
                    
                }
                
            case .failure(let error):
                print(error)
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
