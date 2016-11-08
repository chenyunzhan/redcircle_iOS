//
//  MeController.swift
//  redcircle
//
//  Created by zhan on 16/11/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit

class MeController: UITableViewController {
    
    
    var tableData: NSMutableArray?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "我的"
        
        let userDic = UserDefaults.standard.dictionary(forKey: "USER_INFO")
        let cellModel1 = CellModel()
        cellModel1.title = "手机"
        cellModel1.desc = userDic?["mePhone"] as! String
        
        let cellModel2 = CellModel()
        cellModel2.title = "性别"
        cellModel2.desc = userDic!["sex"] as! String
        
        let cellModel3 = CellModel()
        cellModel3.title = "姓名"
        cellModel3.desc = userDic!["name"] as! String
        
        let cellModel4 = CellModel()
        cellModel4.title = "退出登录"
        cellModel4.desc = ""
        
        let cellModel5 = CellModel()
        cellModel5.title = "头像"
        cellModel5.image = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + (userDic!["mePhone"] as! String)
        let cellModel6 = CellModel()
        cellModel6.title = "红圈"
        cellModel6.desc = ""
        
        let cellModel7 = CellModel()
        cellModel7.title = "朋友圈"
        cellModel7.desc = ""
        
        let cellModel8 = CellModel()
        cellModel8.title = "相册"
        cellModel8.desc = ""
        
        
        self.tableData = NSMutableArray()
        
        
        if #available(iOS 9.0, *) {
            self.tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        
        let sectionArray1 = NSMutableArray()
        sectionArray1.add(cellModel1)
        sectionArray1.add(cellModel3)
        sectionArray1.add(cellModel2)
        
        let sectionArray2 = NSMutableArray()
        sectionArray2.add(cellModel4)
        
        let sectionArray3 = NSMutableArray()
        sectionArray3.add(cellModel5)
        
        let sectionArray4 = NSMutableArray()
        sectionArray4.add(cellModel6)
        sectionArray4.add(cellModel7)
        sectionArray4.add(cellModel8)
        
        self.tableData?.add(sectionArray3)
        self.tableData?.add(sectionArray4)
        self.tableData?.add(sectionArray1)
        self.tableData?.add(sectionArray2)
        
        NotificationCenter.default.addObserver(self, selector:#selector(MeController.userInfoChange),
                                                         name: NSNotification.Name(rawValue: "USER_INFO_CHANGE"), object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (self.tableData?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionArray = self.tableData![section]
        return (sectionArray as! NSArray).count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "reuseIdentifier")
        }
        
        let cellModel = (self.tableData![indexPath.section] as! NSArray)[indexPath.row] as! CellModel
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.textLabel?.text = cellModel.title
        cell?.detailTextLabel?.text = cellModel.desc
        
        
        return cell!
    }
    
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2) {
//            let cellModel = (self.tableData![indexPath.section] as! NSArray)[indexPath.row] as! CellModel
//            let modifyController = ModifyController()
//            modifyController.subTitle = cellModel.title
//            modifyController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(modifyController, animated: true)
        } else if (indexPath.section == 3) {
            let loginController = LoginController()
            let loginNavController = UINavigationController(rootViewController: loginController)
            UIView.transition(from: self.view, to: loginController.view, duration: 0.5, options: .transitionFlipFromLeft, completion: { (Bool) in
                ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController = loginNavController
            })
            
            let appDomain = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            
        } else if(indexPath.section == 0) {
//            self.pickPhoto()
        } else if(indexPath.section == 1) {
//            let meCircle = MeCircleController()
//            if(indexPath.row == 0) {
//                meCircle.circleLevel = "2"
//            } else if (indexPath.row == 1) {
//                meCircle.circleLevel = "1"
//            } else if (indexPath.row == 2) {
//                meCircle.circleLevel = "0"
//            }
//            
//            
//            meCircle.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(meCircle, animated: true)
        }
    }


    func userInfoChange () {
        self.viewDidLoad()
        self.tableView.reloadData()
    }

}
