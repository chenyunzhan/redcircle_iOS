//
//  BookTableViewCell.swift
//  redcircle
//
//  Created by zhan on 16/11/2.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    var  nameLabel : UILabel!
    var  descLabel : UILabel!
    var  intimacyButton : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // 初始化cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: BookTableViewCell.cellID())
        
        // 头像img
        nameLabel = UILabel()
        descLabel = UILabel()
        intimacyButton = UIButton()
        
        
        descLabel.font = UIFont.systemFont(ofSize: 12)
        
        let image = UIImage.fontAwesomeIcon(name: .heartbeat, textColor: UIColor.lightGray, size: CGSize(width: 18, height: 18))
//        let image = UIImage.fontAwesomeIconWithName(.Heartbeat, textColor: UIColor.lightGrayColor(), size: CGSizeMake(18, 18))
        intimacyButton.setTitleColor(UIColor.lightGray, for: .normal)
        intimacyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        intimacyButton.setImage(image, for: .normal)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(descLabel)
        self.contentView.addSubview(intimacyButton)
        
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(20)
            make.left.equalTo(self.contentView).offset(20)
        }
        
        intimacyButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-8)
        }
        
        descLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(nameLabel.snp.right).offset(8)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 根据model 填充Cell
    func cellForModel(model: NSDictionary){
        let friend = model
        
        intimacyButton.setTitle(friend["intimacy"] as? String, for: .normal)

        let name = friend["name"] as? String
        
        if name != "" {
            nameLabel.text = friend["name"] as? String
        } else {
            nameLabel.text = friend["mePhone"] as? String
        }

        if friend["recommendLanguage"] as! String != ""{
            descLabel.text = "(" + (friend["recommendLanguage"] as! String) + ")"
        } else {
            descLabel.text = ""
        }
    }
    
    
    // 类方法 重用标识符
    class func cellID () -> String {
        return "BookTableViewCell"
    }

}
