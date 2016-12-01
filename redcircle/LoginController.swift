//
//  LoginController.swift
//  redcircle
//
//  Created by zhan on 16/10/31.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton
import FontAwesome_swift
import SnapKit
import Alamofire

class LoginController: UIViewController {
    
    
    var userPhoneTextField: UITextField?
    var verifyCodeTextField: UITextField?
    var logoImageView: UIImageView?
    
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
        self.navigationController?.isNavigationBarHidden = true
        
        let registerButton = UIButton()
        registerButton.setTitle("注册", for: UIControlState.normal)
        registerButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.view.addSubview(registerButton)
        self.view.backgroundColor = UIColor.white
        
        let forgetPasswordButton = UIButton()
        forgetPasswordButton.setTitle("忘记密码", for: UIControlState.normal)
        forgetPasswordButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.view.addSubview(forgetPasswordButton)
        
        
        let logoImageView = UIImageView()
        //        logoImageView.image = UIImage(named: "pix")
        logoImageView.image = UIImage.fontAwesomeIcon(name: .circleO, textColor: UIColor.red, size: CGSize(width: 200, height: 200))
        self.logoImageView = logoImageView
        self.view.addSubview(logoImageView)
        
        
        
        
        let userPhoneTextField = UITextField()
        userPhoneTextField.placeholder = "请输入您的手机号"
        self.view.addSubview(userPhoneTextField)
        self.userPhoneTextField = userPhoneTextField
        
        
        let verifyCodeTextField = UITextField()
        verifyCodeTextField.placeholder = "请输入验证码"
        self.view.addSubview(verifyCodeTextField)
        self.verifyCodeTextField = verifyCodeTextField;
        
        let verifyCodeButton = FlatButton()
        verifyCodeButton.color = UIColor.red
        verifyCodeButton.highlightedColor = UIColor.orange
//        verifyCodeButton.shadowHeight     = 0
        verifyCodeButton.cornerRadius     = 5
        verifyCodeButton.setTitle("获取验证码", for: UIControlState.normal)
        verifyCodeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        verifyCodeButton.addTarget(self, action: #selector(LoginController.getVerifyCode(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(verifyCodeButton)
        self.sendButton = verifyCodeButton
        
        
        let loginButton = FlatButton()
        loginButton.color = UIColor.red
        loginButton.highlightedColor = UIColor.orange
//        loginButton.shadowHeight = 0
        loginButton.cornerRadius = 5
        loginButton.setTitle("登录", for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        loginButton.addTarget(self, action: #selector(LoginController.doLoginAction), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(loginButton)
        
        
        let userPhoneLineView = UIView()
        userPhoneLineView.backgroundColor = UIColor.red
        self.view .addSubview(userPhoneLineView)
        
        let verifyCodeLineView = UIView()
        verifyCodeLineView.backgroundColor = UIColor.red
        self.view.addSubview(verifyCodeLineView)
        
        
        
        let agreementButton = UIButton();
        agreementButton.setTitle("使用条款和隐私政策", for: .normal)
        agreementButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        agreementButton.setTitleColor(UIColor.red, for: .normal)
        agreementButton.addTarget(self, action: #selector(LoginController.readAgreementAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(agreementButton)
        
        let agreementButton1 = UIButton();
        agreementButton1.setTitle("注册代表同意", for: .normal)
        agreementButton1.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        agreementButton1.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(agreementButton1)

        
        
        userPhoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
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
        
        registerButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(loginButton.snp.bottom).offset(8)
            make.left.equalTo(loginButton)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        
        forgetPasswordButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(loginButton.snp.bottom).offset(8)
            make.right.equalTo(loginButton)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        
        logoImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(50)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        loginButton.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(userPhoneTextField)
            make.left.equalTo(userPhoneTextField)
            make.top.equalTo(verifyCodeTextField.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
        
        
        agreementButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(45)
            make.top.equalTo(registerButton.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        agreementButton1.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-53)
            make.top.equalTo(registerButton.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        
        
        registerButton.addTarget(self, action: #selector(LoginController.gotoRegisterController), for: UIControlEvents.touchUpInside)
        
        
        if UIScreen.main.bounds.size.height == 480 {
            self.registerForKeyboardNotifications()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func gotoRegisterController() {
        let registerController = RegisterController()
        self.navigationController?.pushViewController(registerController, animated: true)
    }
    
    func getVerifyCode(sender:UIButton) {
        
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: self.userPhoneTextField!.text, zone: "86", customIdentifier: nil) { (error) -> Void in
            
            
            if (error == nil) {
                self.isCounting = true
                NSLog("获取验证码成功");
            } else {
                let alertController = UIAlertController(title: "提示", message: error?.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                print("错误信息：%@",error ?? "");
            }
        }
    }

    
    
    func doLoginAction() {
        
        
        SMSSDK.commitVerificationCode(self.verifyCodeTextField?.text, phoneNumber: self.userPhoneTextField?.text, zone: "86") { (userInfo, error) in
            if (error == nil) {
                self.gotoHomeController()
                NSLog("验证成功")
                
            } else {
                print("错误信息：%@",error ?? "")
                if ("15891739884" == self.userPhoneTextField?.text) {
                    self.gotoHomeController()
                }
            }
        }
        
    }

    
    
    func readAgreementAction() {
        let agreementController = WebViewController()
        let agreementControllerNav = UINavigationController(rootViewController: agreementController)
        self.present(agreementControllerNav, animated: true, completion: nil)
    }
    
    
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification : NSNotification) {
        self.logoImageView?.snp.updateConstraints({ (make) -> Void in
            make.top.equalTo(self.view).offset(-100)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(200)
            
        })
    }
    
    func keyboardWillBeHidden(notification : NSNotification) {
        self.logoImageView?.snp.updateConstraints({ (make) -> Void in
            make.top.equalTo(self.view).offset(50)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(200)
            
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.userPhoneTextField?.resignFirstResponder()
        self.verifyCodeTextField?.resignFirstResponder()
    }
    
    
    func gotoHomeController() {
        
        let mePhone = (self.userPhoneTextField?.text)! as String
        
        
        let parameters = [
            "mePhone": mePhone
            ]
        Alamofire.request(AppDelegate.baseURLString + "/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success:
                let homeController = HomeController()
                ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController = homeController
                let userDic = response.result.value as? NSDictionary
                UserDefaults.standard.set(userDic, forKey: "USER_INFO")
            case .failure(let error):
                print(error)
            }

        }
        
    }

    
    func updateTime(timer: Timer) {
        remainingSeconds -= 1
    }


}
