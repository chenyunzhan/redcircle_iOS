//
//  FriendController.swift
//  redcircle
//
//  Created by zhan on 16/11/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton
import Alamofire


class FriendController: UIViewController {

    var meInfo: NSDictionary?
    var friendArray: NSMutableArray?

    var userPhoneTextField: UITextField?
    var verifyCodeTextField: UITextField?
    
    var sendButton: FlatButton!
    
    var countdownTimer: Timer?
    
    var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle("\(newValue)", for: .normal)
            
            if newValue <= 0 {
                sendButton.setTitle("重新获取", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                
                remainingSeconds = 100
                
                sendButton.color = UIColor.gray
                //                sendButton.buttonColor  = UIColor.grayColor()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                sendButton.color = UIColor.red
                
                //                sendButton.buttonColor  = UIColor.redColor()
            }
            
            sendButton.isEnabled = !newValue
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "朋友信息"
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成注册", style: UIBarButtonItemStyle.done, target: self, action: #selector(FriendController.doResigterAction))
        
        let userPhoneTextField = UITextField()
        userPhoneTextField.placeholder = "请输入朋友的手机号"
        self.view.addSubview(userPhoneTextField)
        self.userPhoneTextField = userPhoneTextField
        
        
        let verifyCodeTextField = UITextField()
        verifyCodeTextField.placeholder = "请输入验证码"
        self.view.addSubview(verifyCodeTextField)
        self.verifyCodeTextField = verifyCodeTextField
        
        let verifyCodeButton = FlatButton()
        verifyCodeButton.color = UIColor.red
        verifyCodeButton.highlightedColor = UIColor.orange
        //        verifyCodeButton.shadowHeight     = 0
        verifyCodeButton.cornerRadius     = 5
        verifyCodeButton.setTitle("获取验证码", for: UIControlState.normal)
        verifyCodeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        verifyCodeButton.addTarget(self, action: #selector(FriendController.getVerifyCode(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(verifyCodeButton)
        self.sendButton = verifyCodeButton
        
        
        let userPhoneLineView = UIView()
        userPhoneLineView.backgroundColor = UIColor.red
        self.view .addSubview(userPhoneLineView)
        
        let verifyCodeLineView = UIView()
        verifyCodeLineView.backgroundColor = UIColor.red
        self.view.addSubview(verifyCodeLineView)
        
        userPhoneTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(114)
            make.right.equalTo(self.view).offset(-20)
            make.left.equalTo(self.view).offset(20)
            make.height.equalTo(40)
        }
        
        
        verifyCodeTextField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userPhoneTextField.snp.bottom).offset(8)
            make.left.equalTo(self.view).offset(20)
            make.height.equalTo(40)
        }
        
        
        verifyCodeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(userPhoneTextField.snp.bottom).offset(8)
            make.right.equalTo(self.view).offset(-20)
            make.left.equalTo(verifyCodeTextField.snp.right).offset(10)
            make.width.equalTo(130)
            make.height.equalTo(40)
        }
        
        
        userPhoneLineView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(userPhoneTextField.snp.bottom)
            make.right.equalTo(userPhoneTextField)
            make.left.equalTo(userPhoneTextField)
            make.height.equalTo(1)
        }
        
        
        verifyCodeLineView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(verifyCodeTextField.snp.bottom)
            make.right.equalTo(verifyCodeTextField)
            make.left.equalTo(verifyCodeTextField)
            make.height.equalTo(1)
        }
        

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func doResigterAction() {
        SMSSDK.commitVerificationCode(self.verifyCodeTextField?.text, phoneNumber: self.userPhoneTextField?.text, zone: "86") { (userInfo, error) in
            if ((error == nil)) {
                NSLog("验证成功");
                let friendController = FriendController()
                friendController.meInfo = NSDictionary(dictionary: ["me_phone":(self.userPhoneTextField?.text)!])
                self.navigationController?.pushViewController(friendController, animated: true)
            } else {
                print("错误信息：%@",error);
            }
        }
    }

    
    func getVerifyCode(sender:UIButton) {
        
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: self.userPhoneTextField!.text, zone: "86", customIdentifier: nil) { (error) -> Void in
            
            
            if (error == nil) {
                self.isCounting = true
                NSLog("获取验证码成功");
                self.friendArray = []
                let friendDic: [String: String] = ["phone_text": (self.userPhoneTextField?.text)!, "verify_code_text": (self.verifyCodeTextField?.text)!]
                self.friendArray?.add(friendDic)
                
                let parameters = [
                    "friendArrayMap": self.friendArray as AnyObject,
                    "meInfo": self.meInfo as AnyObject
                ]
                
                
                Alamofire.request(AppDelegate.baseURLString + "/register", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
                    
                    switch response.result {
                    case .success:
                        let alertController = UIAlertController(title: "提示", message: "注册成功", preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                        self.perform(#selector(FriendController.backLoginController), with: self, afterDelay: 3)
                    case .failure(let error):
                        print(error)
                    }
                    
                }
                
                
                
//                Alamofire.request(.POST, AppDelegate.baseURLString + "/register", parameters: parameters, encoding: .JSON).responseJSON { response in
//                    
//                    if(response.result.isSuccess) {
//                        let success = response.result.value!["success"]!! as! NSNumber
//                        if(success.boolValue) {
//                            let alertController = UIAlertController(title: "提示", message: "注册成功", preferredStyle: UIAlertControllerStyle.Alert)
//                            let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
//                            alertController.addAction(cancelAction)
//                            self.presentViewController(alertController, animated: true, completion: nil)
//                            self.performSelector("backLoginController", withObject: self, afterDelay: 3)
//                        } else {
//                            
//                        }
//                        
//                    }
//                    
//                }
                
                
                
            } else {
                let alertController = UIAlertController(title: "提示", message: error?.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                print("错误信息：%@",error);
            }
        }
        
    }
    
    
    
    func updateTime(timer: Timer) {
        remainingSeconds -= 1
    }
    
    
    
    func backLoginController() {
       _ = self.navigationController?.popToRootViewController(animated: true)
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
