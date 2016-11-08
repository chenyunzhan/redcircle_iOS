//
//  RegisterController.swift
//  redcircle
//
//  Created by zhan on 16/11/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton


class RegisterController: UIViewController {
    
    
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

        self.title = "个人信息"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.done, target: self, action: #selector(RegisterController.gotoFriendController))
        
        
        
        
        
        
        
        
        let userPhoneTextField = UITextField()
        userPhoneTextField.placeholder = "请输入您的手机号"
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
        verifyCodeButton.addTarget(self, action: #selector(RegisterController.getVerifyCode(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(verifyCodeButton)
        self.sendButton = verifyCodeButton
        
        
        let agreementButton = UIButton();
        agreementButton.setTitle("使用条款和隐私政策", for: .normal)
        agreementButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        agreementButton.setTitleColor(UIColor.red, for: .normal)
        agreementButton.addTarget(self, action: #selector(RegisterController.readAgreementAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(agreementButton)
        
        let agreementButton1 = UIButton();
        agreementButton1.setTitle("注册代表同意", for: .normal)
        agreementButton1.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        agreementButton1.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(agreementButton1)
        
        
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
        
        
        agreementButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(45)
            make.top.equalTo(verifyCodeButton.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        agreementButton1.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-53)
            make.top.equalTo(verifyCodeButton.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getVerifyCode(sender:UIButton) {
        
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: self.userPhoneTextField!.text, zone: "86", customIdentifier: nil) { (error) -> Void in
            
            

            
            if (error == nil) {
                self.isCounting = true
                NSLog("获取验证码成功");
            } else {
                
                let result = error as! NSError
                let userInfo = result.userInfo as NSDictionary
                let alertController = UIAlertController(title: "提示", message: userInfo.value(forKey: "getVerificationCode") as! String?, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                print("错误信息：%@",error);
            }
        }
        
    }
    
    
    func gotoFriendController() {
        
        SMSSDK.commitVerificationCode(self.verifyCodeTextField?.text, phoneNumber: self.userPhoneTextField?.text, zone: "86") { (userInfo, error) in
            
            if ((error == nil)) {
                print("验证成功");
                self.doGotoFriendController()
            } else {
                print("错误信息：%@",error);
            }
        }
        
        
        
    }
    
    
    func doGotoFriendController() {
        let friendController = FriendController()
        friendController.meInfo = NSDictionary(dictionary: ["me_phone":self.userPhoneTextField?.text])
        self.navigationController?.pushViewController(friendController, animated: true)
    }

    
    func readAgreementAction() {
        let agreementController = WebViewController()
        let agreementControllerNav = UINavigationController(rootViewController: agreementController)
        self.present(agreementControllerNav, animated: true, completion: nil)
    }
    
    func updateTime(timer: Timer) {
        remainingSeconds -= 1
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
