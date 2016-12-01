//
//  ArticleTableViewCell.swift
//  redcircle
//
//  Created by zhan on 16/11/23.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import ActiveLabel


class ArticleTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    
    var controller: MeCircleController!
    var  nameLabel : UILabel!
    var  contentLabel : ActiveLabel!
    var  commentButton : UIButton!
    var  photoImageView : UIImageView!
    var  imageCollectionView : UICollectionView!
    var  commentTableView: UITableView!
    var  createLabel : UILabel!
    
    
    var  imageData : [String]?
    var  commentData : [Any]?
    
    var  widthConstraint: Constraint?
    var  heightConstraint: Constraint?
    var  heightConstraintOfComment: Constraint?
    
    
    // 初始化cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: BookTableViewCell.cellID())
        
        
        
        // 头像img
        nameLabel = UILabel()
        contentLabel = ActiveLabel()
        
        
        commentButton = UIButton()
        createLabel = UILabel()
        photoImageView = UIImageView()
        imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init());
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CommandCell")
        imageCollectionView.backgroundColor = UIColor.clear
        commentButton.setImage(UIImage(named: "bg_comment_pressed"), for: .normal)
        commentButton.addTarget(self, action: #selector(ArticleTableViewCell.addCommentToArticle), for: .touchUpInside)
        commentTableView = UITableView()
        commentTableView.delegate = self
        commentTableView.dataSource = self
//        commentTableView.backgroundView = UIImageView.init(image: UIImage(named: "comment_table_back_image")?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 20, 5, 5)))
        commentTableView.backgroundColor = UIColor.clear
        commentTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        commentTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        commentTableView.separatorStyle = .none
        commentTableView.isScrollEnabled = false
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(imageCollectionView)
        self.contentView.addSubview(createLabel)
        self.contentView.addSubview(commentButton)
        self.contentView.addSubview(commentTableView)
        //        self.contentView.addSubview(tableView)
        
        
        photoImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.top.equalTo(16)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(20)
            make.left.equalTo(photoImageView.snp.right).offset(8)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(photoImageView.snp.right).offset(8)
            make.right.equalTo(-8)
            
        }
        
        imageCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.left.equalTo(photoImageView.snp.right).offset(8)
            widthConstraint = make.width.equalTo(0).constraint
            heightConstraint = make.height.equalTo(80).constraint
        }
        
        commentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(createLabel.snp.bottom).offset(8)
            make.left.equalTo(photoImageView.snp.right).offset(8)
            make.right.equalTo(-8)
            heightConstraintOfComment = make.height.equalTo(80).constraint
        }
        
        createLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(8)
            make.left.equalTo(photoImageView.snp.right).offset(8)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(8)
            make.trailing.equalTo(-8)
        }
        
        //        tableView.snp_makeConstraints { (make) in
        //            make.top.equalTo(contentLabel.snp_bottom).offset(10)
        //            make.left.equalTo(photoImageView.snp_right).offset(8)
        //            make.width.equalTo(50)
        //            make.height.equalTo(50)
        //            
        //        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCommentToArticle(sender: UIButton) -> Void {
        controller.keyboardTextField.show()
        controller.keyboardTextField.isHidden = false
        controller.toComment = ["commenter_by":"","article_id":(sender.titleLabel?.text)!]
        controller.indexOfArticle = self.tag
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.commentData == nil) {
            return 0
        }
        return (self.commentData?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = self.commentData![indexPath.row] as! NSDictionary
        
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        
        var commenterBy = comment["commenter_by_name"] as! String
        if commenterBy == "" {
            commenterBy = comment["commenter_by"] as! String
        }
        
        var commenterTo = comment["commenter_to_name"] as? String
        if commenterTo == "" {
            commenterTo = comment["commenter_to"] as? String
        }
        
        cell.textLabel?.text = commenterBy + ": " + (comment["content"] as! String)
        
        if commenterTo != nil {
            cell.textLabel?.text = commenterBy + "回复" + commenterTo! + ": " + (comment["content"] as! String)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.imageData?.count)!-1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let identify:String = "CommandCell"
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
//            identify, forIndexPath: indexPath) as UICollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identify, for: indexPath) as UICollectionViewCell
        
        let imageView = UIImageView()
        
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(cell.contentView).inset(UIEdgeInsetsMake(2, 2, 2, 2))
        }
        
        
        
        let imageUrl = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + self.imageData![indexPath.row] + "&type=thumbnail"
        Alamofire.request(imageUrl).responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data)
                imageView.image = image
                
            }
        }
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.seeImages(imageData: imageData!, index: indexPath.row)
    }
    
    // 根据model 填充Cell
    func cellForModel(model: NSDictionary?){
        if let friend = model {
//            if ((friend["recommendLanguage"] as! String).characters.count > 0) {

            
            if ((friend["name"] as! String).characters.count > 0) {
                nameLabel.text = friend["name"] as? String
            } else {
                nameLabel.text = friend["created_by"] as? String
            }
            let imageUrl = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + (friend["created_by"] as! String) + "&type=thumbnail"
//            Alamofire.request(.GET, imageUrl).response { (request, response, data, error) in
//                self.photoImageView.image = UIImage(data: data!, scale:1)
//            }
//            
            Alamofire.request(imageUrl).responseData { response in
                if let data = response.result.value {
                    let image = UIImage(data: data)
                    self.photoImageView.image = image
                    
                }
            }
            
            
           contentLabel.customize { label in
            
                label.text = (friend["content"] as! String).replacingOccurrences(of: "http", with: " http")
            
                
                label.numberOfLines = 0
                label.lineSpacing = 4
                
                label.textColor = UIColor(red: 102.0/255, green: 117.0/255, blue: 127.0/255, alpha: 1)
                label.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
                label.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
                label.URLColor = UIColor(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
                label.URLSelectedColor = UIColor(red: 82.0/255, green: 190.0/255, blue: 41.0/255, alpha: 1)
                
                label.handleMentionTap { self.alert(title: "Mention", message: $0) }
                label.handleHashtagTap { self.alert(title: "Hashtag", message: $0) }
                label.handleURLTap { self.alert(title: "URL", message: $0.absoluteString) }
            }
            
            createLabel.text = friend["created_at"] as? String
            
            
            commentButton.titleLabel?.text = friend["id"] as? String
            
            let imageData = (friend["images"] as! String).components(separatedBy: "#")
            
            self.imageData = imageData
            self.imageCollectionView .reloadData()
            
            let commentData = friend["comments"] as! [NSDictionary]
            self.commentData = commentData
            self.commentTableView.reloadData()
            
            widthConstraint?.update(offset: (self.imageData?.count)!*80-80)
            
            if self.imageData?.count == 1 {
                heightConstraint?.update(offset: 0)
            } else {
                heightConstraint?.update(offset: 80)
            }
            
            if self.commentData?.count == 0 {
                heightConstraintOfComment?.update(offset: 0)
            } else {
                heightConstraintOfComment?.update(offset: (self.commentData?.count)! * 20 + 20)
            }
        }
    }
    
    
    class func heightForModel(model: NSDictionary?) -> CGFloat {
        
        if let friend = model {
            let imageData = (friend["images"] as! String).components(separatedBy: "#")
            let count = (imageData.count)-1
            var row = 0
            
            if (0 < count && count <= 3) {
                row = 1
            } else if(3 < count && count <= 6) {
                row = 2
            } else if(6 < count) {
                row = 3
            }
            
            
            let commentData = friend["comments"] as! [NSDictionary]
            
            
            let myRect:CGRect = UIScreen.main.bounds
            
            return CGFloat(row * 80) + 125 + getLabHeigh(labelStr: friend["content"] as! String, font: UIFont.systemFont(ofSize: 17), width: myRect.width-72) + CGFloat(((commentData.count) * 20))
        }
        return 44
    }
    
    
    class func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: width, height: 900)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 类方法 重用标识符
    class func cellID () -> String {
        return "ArticleTableViewCell"
    }
    
    func alert(title: String, message: String) {
        let url = NSURL(string: message) as! URL
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}
