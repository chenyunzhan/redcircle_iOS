//
//  MeCircleController.swift
//  redcircle
//
//  Created by zhan on 16/11/23.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import Alamofire
import SKPhotoBrowser


class MeCircleController: UITableViewController, SKPhotoBrowserDelegate {

    var circleLevel: String?
    var keyboardheight : CGFloat!
    var loadMoreLabel: UILabel?
    var loadMoreIndicatorView: UIActivityIndicatorView?
    var startNo: String?
    var mePhone: String?
    var tableData: [NSDictionary] = []
    var keyboardTextField: DNKeyboardTextField!
    var toComment: NSDictionary?
    var indexOfArticle: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.keyboardheight = 0
        
        
        self.tableView.register(ArticleTableViewCell.classForCoder(), forCellReuseIdentifier: ArticleTableViewCell.cellID())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MeCircleController.addArticleAction))
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(n), style: .Done, target: self, action: #selector(MeCircleController.addArticleAction))
        if #available(iOS 9.0, *) {
            self.tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        
        self.refreshData()
        
        
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.refreshData()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        
        let loadMoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        loadMoreLabel.textAlignment = .center
        loadMoreLabel.text = "上拉加载更多"
        loadMoreLabel.textColor = UIColor.gray
        //        loadMoreLabel.backgroundColor = UIColor.lightGrayColor()
        self.loadMoreLabel = loadMoreLabel
        
        let loadMoreIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 30))
        loadMoreIndicatorView.color = UIColor.gray
        self.loadMoreIndicatorView = loadMoreIndicatorView
        
        self.tableView.tableFooterView = loadMoreLabel
        
        NotificationCenter.default.addObserver(self, selector: #selector(MeCircleController.keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MeCircleController.keyboardWillDisappear(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func loadView() {
        super.loadView()
//        keyboardTextField = SYKeyboardTextField(point: CGPointMake(0, 0), width: self.view.width)
//        keyboardTextField.delegate = self
//        keyboardTextField.leftButtonHidden = true
//        keyboardTextField.rightButtonHidden = false
//        keyboardTextField.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleTopMargin]
//        self.view.addSubview(keyboardTextField)
//        keyboardTextField.toFullyBottom()
//        keyboardTextField.hidden = true
        
        
        
        keyboardTextField = DNKeyboardTextField(point: CGPoint(x: 0, y: 0), width: self.view.bounds.size.width)
        keyboardTextField.delegate = self
        keyboardTextField.isLeftButtonHidden = true
        keyboardTextField.isRightButtonHidden = false
        keyboardTextField.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleTopMargin]
        self.view.addSubview(keyboardTextField)
        keyboardTextField.toFullyBottom()
        keyboardTextField.isHidden = true

    }
    
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (Float(scrollView.contentOffset.y) >= fmaxf(0, Float(scrollView.contentSize.height - scrollView.frame.size.height)) + 30) //x是触发操作的阀值
        {
            //触发上拉刷新
            self.loadMoreData()
            
            
        }
        

        
        
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        keyboardTextField.hide()
        keyboardTextField.isHidden = true
    }
    
    
    func loadMoreData() -> Void {
        
        self.tableView.tableFooterView = self.loadMoreIndicatorView
        self.loadMoreIndicatorView?.startAnimating()
        
        startNo = String(Int(startNo!)! + 10)
        
        let parameters = [
            "mePhone": mePhone!,
            "circleLevel": circleLevel!,
            "startNo": startNo!
        ]
        
        
        Alamofire.request(AppDelegate.baseURLString + "/getArticles", method: .get, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let JSONObject = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [NSDictionary],
                    let tableData = JSONObject {
                    
                    
                    self.tableView.tableFooterView = self.loadMoreLabel
                    self.loadMoreIndicatorView?.stopAnimating()
                    
                    self.tableData = self.tableData + tableData
                    self.tableView.reloadData()
                    self.tableView.dg_stopLoading()
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
    
    func addArticleAction() {
        let addArticle = AddArticleController()
        addArticle.initWithClosure(closure: someFunctionThatTakesAClosure)
        
        self.navigationController?.pushViewController(addArticle, animated: true)
    }
    
    
    func someFunctionThatTakesAClosure(string:String) -> Void {
        self.viewDidLoad()
    }
    
    func refreshData() -> Void {
        if(circleLevel == "0") {
            self.title = "相册"
        } else if (circleLevel == "1") {
            self.title = "朋友圈"
        } else if (circleLevel == "2") {
            self.title = "红圈"
        }
        
        startNo = "0"
        
        
        if(mePhone == nil) {
            let userDic = UserDefaults.standard.object(forKey: "USER_INFO") as! NSDictionary
            mePhone = userDic["mePhone"] as? String
        }
        
        
        
        let parameters = [
            "mePhone": mePhone!,
            "circleLevel": circleLevel!,
            "startNo": startNo!
        ]
        
        Alamofire.request(AppDelegate.baseURLString + "/getArticles", method: .get, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let JSONObject = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [NSDictionary],

                    let tableData = JSONObject {
                    self.tableData = tableData
                    self.tableView.reloadData()
                    self.tableView.dg_stopLoading()
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
    
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
//        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
//        
//        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
//        
//        
//        self.keyboardheight = keyboardheight
//        
//        print("键盘弹起")
//        
//        print(keyboardheight)
        
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        
        print("键盘落下")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.cellID(), for: indexPath) as! ArticleTableViewCell
        
        let article = self.tableData[indexPath.row]
        cell.controller = self
        cell.cellForModel(model: article)
        cell.tag = indexPath.row
        
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let article = self.tableData[indexPath.row]
        return ArticleTableViewCell.heightForModel(model: article)
    }
    
    
    func seeImages(imageData: [String], index: Int) -> Void {
        var images = [SKPhoto]()
        
        
        for imageStr in imageData {
            if (imageStr != "") {
                let photo = SKPhoto.photoWithImageURL(AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + imageStr)
                images.append(photo)
            }
            
        }
        
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(index)
        browser.delegate = self
        present(browser, animated: true, completion: {})
    }


}


//MARK: SYKeyboardTextFieldDelegate
extension MeCircleController : SYKeyboardTextFieldDelegate {
    func keyboardTextFieldPressReturnButton(_ keyboardTextField: SYKeyboardTextField) {
//        UIAlertView(title: "", message: "Action", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    
    func keyboardTextFieldPressRightButton(_ keyboardTextField: SYKeyboardTextField) {
        keyboardTextField.hide()
        keyboardTextField.isHidden = true
        self.sendComment()
    }
    
    
    func sendComment() -> Void {
        let userDic = UserDefaults.standard.dictionary(forKey: "USER_INFO")
        //        let parameters = [
        //            "mePhone": self.userPhoneTextField?.text as! AnyObject,
        //            ]
        
        
        
        if  let article_id = self.toComment!["article_id"],
            let comment_by = userDic!["mePhone"],
            let comment_to = self.toComment!["commenter_by"]
        {
            
            let parameters = [
                "articleId": article_id,
                "content"  : keyboardTextField.text,
                "commentBy": comment_by,
                "commentTo": comment_to
            ]
            
            
            
            
            Alamofire.request(AppDelegate.baseURLString + "/addComment", method: .post, parameters: parameters).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    
                    if let JSONObject = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [NSDictionary],
                        let tableData = JSONObject {

                        let tempDic = self.tableData[self.indexOfArticle!]
                        let tempMutableDic = NSMutableDictionary(dictionary: tempDic)
                        tempMutableDic.setValue(tableData, forKey: "comments")
                        self.tableData[self.indexOfArticle!] = tempMutableDic
                        //                    self.tableData[self.indexOfArticle!].setValue(tableData, forKey: "comments")
                        self.tableView.reloadData()
                    }
                    
                    
                case .failure(let error):
                    print(error)
                }
                
            }
        }
        

    }
    
}


extension UIView {
    func toFullyBottom() {
        self.bottom = superview!.bounds.size.height
        self.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleWidth]
    }
    
    public var bottom: CGFloat{
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame;
            frame.origin.y = newValue - frame.size.height;
            self.frame = frame;
        }
    }
}




class DNKeyboardTextField : SYKeyboardTextField {
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        self.clearTestColor()
        
        //Right Button
        self.rightButton.showsTouchWhenHighlighted = true
        self.rightButton.backgroundColor = UIColor.black
        self.rightButton.clipsToBounds = true
        self.rightButton.layer.cornerRadius = 18
        self.rightButton.setTitle("发送", for: .normal)
        self.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        //TextView
        self.textViewBackground.layer.borderColor = UIColor.black.cgColor
        self.textViewBackground.backgroundColor = UIColor.white
        self.textViewBackground.layer.cornerRadius = 18
        self.textViewBackground.layer.masksToBounds = true
        self.keyboardView.backgroundColor = UIColor.black
        self.placeholderLabel.textAlignment = .center
        self.placeholderLabel.text = "评论"
        self.placeholderLabel.textColor = UIColor.black
        
        self.leftRightDistance = 15.0
        self.middleDistance = 5.0
        self.buttonMinWidth = 60
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
