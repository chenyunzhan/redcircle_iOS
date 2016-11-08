//
//  ModifyRelationController.swift
//  redcircle
//
//  Created by zhan on 16/11/8.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit


typealias sendValueClosure=(_ string:String)->Void


class ModifyRelationController: UIViewController {
    
    
    
    var mePhone: String?
    var friendPhone: String?
    var textField: UITextField?
    
    //声明一个闭包
    var myClosure:sendValueClosure?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func initWithClosure(closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
