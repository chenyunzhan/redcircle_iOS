//
//  AddFriendController.swift
//  redcircle
//
//  Created by zhan on 16/12/6.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SwiftyButton
import Alamofire


class AddFriendController: UIViewController {
    
    
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
    
    
    //声明一个闭包
    var myClosure:sendValueClosure?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func initWithClosure(closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "朋友信息"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.done, target: self, action: #selector(doAddFriendAction))
        
        
        
        
        
        
        
        
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
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func doAddFriendAction() {
        SMSSDK.commitVerificationCode(self.verifyCodeTextField?.text, phoneNumber: self.userPhoneTextField?.text, zone: "86") { (userInfo, error) in
            
            if ((error == nil)) {
                print("验证成功");
                self.doAddFriend()
            } else {
                print("错误信息：%@",error);
            }
        }
    }
    
    func updateTime(timer: Timer) {
        remainingSeconds -= 1
    }
    
    
    func doAddFriend() {
        let userDic = UserDefaults.standard.dictionary(forKey: "USER_INFO")
        
        let parameters = [
            "mePhone": userDic!["mePhone"] as! String,
            "friendPhone": (self.userPhoneTextField?.text)! as String
            ]
        
        Alamofire.request(AppDelegate.baseURLString + "/addFriend", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                //判空
                if (self.myClosure != nil){
                    //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                    self.myClosure!("好好哦")
                }
                _ = self.navigationController?.popViewController(animated: true)
                
                
            case .failure(let error):
                print(error)
                let alertController = UIAlertController(title: "提示", message: response.result.error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
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
