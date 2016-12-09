//
//  MeController.swift
//  redcircle
//
//  Created by zhan on 16/11/1.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire
import ImagePickerSheetController
import Photos


class MeController: BaseTableViewController {
    
    
    var tableData: NSMutableArray?

    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()

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
        cellModel5.image = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + (userDic!["mePhone"] as! String) + "&type=thumbnail"
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
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 80
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "reuseIdentifier")
        }
        
        if (indexPath.section  == 2 && indexPath.row == 0) {
            cell?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        let cellModel = (self.tableData![indexPath.section] as! NSArray)[indexPath.row] as! CellModel
        cell?.textLabel?.text = cellModel.title
        cell?.detailTextLabel?.text = cellModel.desc
        
        if(indexPath.section == 0) {
            
            
            let imageView = UIImageView()
            cell?.contentView.addSubview(imageView)
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            imageView.snp.makeConstraints({ (make) in
                make.centerY.equalTo((cell?.contentView)!)
                make.right.equalTo((cell?.contentView)!).offset(-18)
                make.height.equalTo(60)
                make.width.equalTo(60)
            })
            
            
            Alamofire.request(cellModel.image).responseData { response in
                if let data = response.result.value {
                    let image = UIImage(data: data)
                    imageView.image = image
                    
                }
            }
            
        }
        
        
        return cell!
    }
    
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 2) {
            if indexPath.row == 0 {
                
            } else {
                let cellModel = (self.tableData![indexPath.section] as! NSArray)[indexPath.row] as! CellModel
                let modifyController = ModifyController()
                modifyController.subTitle = cellModel.title
                modifyController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(modifyController, animated: true)
            }

        } else if (indexPath.section == 3) {
            let loginController = LoginController()
            let loginNavController = UINavigationController(rootViewController: loginController)
            UIView.transition(from: self.view, to: loginController.view, duration: 0.5, options: .transitionFlipFromLeft, completion: { (Bool) in
                ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController = loginNavController
            })
            
            let appDomain = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            
        } else if(indexPath.section == 0) {
            self.pickPhoto()
        } else if(indexPath.section == 1) {
            let meCircle = MeCircleController()
            if(indexPath.row == 0) {
                meCircle.circleLevel = "2"
            } else if (indexPath.row == 1) {
                meCircle.circleLevel = "1"
            } else if (indexPath.row == 2) {
                meCircle.circleLevel = "0"
            }
            
            
            meCircle.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(meCircle, animated: true)
        }
    }


    func userInfoChange () {
        self.viewDidLoad()
        self.tableView.reloadData()
    }
    
    func pickPhoto() {
        
        let presentImagePickerController: (UIImagePickerControllerSourceType) -> () = { source in
            let controller = UIImagePickerController()
            controller.delegate = self
            //            controller.allowsEditing = true
            var sourceType = source
            if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                sourceType = .photoLibrary
                print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
            }
            controller.sourceType = sourceType
            
            self.present(controller, animated: true, completion: nil)
        }
        
        
        let controller = ImagePickerSheetController(mediaType: .imageAndVideo)
        controller.delegate = self
        
        controller.addAction(ImagePickerAction(title: NSLocalizedString("拍照", comment: "Action Title"), secondaryTitle: NSLocalizedString("确定选择", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.camera)
        }, secondaryHandler: { _, numberOfPhotos in
            print("Comment \(numberOfPhotos) photos")
            let originalImage = controller.selectedAssets[0];
            let option = PHContentEditingInputRequestOptions()
            originalImage.requestContentEditingInput(with: option, completionHandler: { (contentEditingInput, info) -> Void in
                let imageURL = contentEditingInput?.fullSizeImageURL
                print(imageURL!)
            })
            
            self.cacheUploadImage(originalImage: originalImage)
                
            
            
            
        }))
        controller.addAction(ImagePickerAction(title: NSLocalizedString("从相册中选取", comment: "Action Title"), secondaryTitle: { NSString.localizedStringWithFormat(NSLocalizedString("从相册中选取", comment: "Action Title") as NSString, $0) as String}, handler: { _ in
            presentImagePickerController(.photoLibrary)
        }, secondaryHandler: { _, numberOfPhotos in
            print("Send \(controller.selectedAssets)")
        }))
        controller.addAction(ImagePickerAction(cancelTitle: NSLocalizedString("取消", comment: "Action Title")))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            controller.modalPresentationStyle = .popover
            controller.popoverPresentationController?.sourceView = view
            controller.popoverPresentationController?.sourceRect = CGRect(origin: view.center, size: CGSize())
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    
    func cacheUploadImage(originalImage:PHAsset) -> Void {
        let options = PHImageRequestOptions()
        options.resizeMode = PHImageRequestOptionsResizeMode.exact
        options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        options.isSynchronous = true
        PHImageManager.default().requestImage(for: originalImage, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
            print(image!)
            let filePath:String = NSHomeDirectory() +  "/Documents/photo_temp.png"
            let data:NSData = UIImagePNGRepresentation(image!)! as NSData
            data.write(toFile: filePath, atomically: true)
        })
        
        
        PHImageManager.default().requestImage(for: originalImage, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
            print(image!)
            let filePath:String = NSHomeDirectory() + "/Documents/photo_temp_thumbnail.png"
            let data:NSData = UIImagePNGRepresentation(image!)! as NSData
            data.write(toFile: filePath, atomically: true)

        })
        
        
        self.uploadPhoto()

        
    }
    
    
    func cacheUploadImageWithTake(originalImage:UIImage) -> Void {
        
        let newImage1 = self.resizeImage(image: originalImage, newSize: CGSize(width: 80, height: 80))
        let filePath1:String = NSHomeDirectory() + "/Documents/photo_temp_thumbnail.png"
        let data1:NSData = UIImagePNGRepresentation(newImage1)! as NSData
        data1.write(toFile: filePath1, atomically: true)
        
        let newImage2 = self.resizeImage(image: originalImage, newSize: CGSize(width: 600, height: 600))
        let filePath2:String = NSHomeDirectory() +  "/Documents/photo_temp.png"
        let data2:NSData = UIImagePNGRepresentation(newImage2)! as NSData
        data2.write(toFile: filePath2, atomically: true)
        
        self.uploadPhoto()
    }
    
    
    func uploadPhoto() {
        
        self.startLoadingView()
        
        
        let fileStr = NSHomeDirectory() + "/Documents/photo_temp.png"
        let fileURL = NSURL(fileURLWithPath: fileStr)
        
        let thumbnailFileStr = NSHomeDirectory() + "/Documents/photo_temp_thumbnail.png"
        let thumbnailFileURL = NSURL(fileURLWithPath: thumbnailFileStr)
        
        let userDic = UserDefaults.standard.dictionary(forKey: "USER_INFO")
        let mePhone = userDic!["mePhone"] as! String + ".png"

        sessionManager.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(mePhone.data(using: String.Encoding.utf8)!, withName: "name")
                multipartFormData.append(fileURL as URL, withName: "file")
                multipartFormData.append(thumbnailFileURL as URL, withName: "thumbnail")
            },
            to: AppDelegate.baseURLString + "/uploadPhoto",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        self.updateUser()
                    }
                case .failure(let encodingError):
                    self.stopLoadingView()
                    print(encodingError)
                }
            }
        )

    }
    
    
    func updateUser() {
        
        let userDic = UserDefaults.standard.object(forKey: "USER_INFO") as! NSDictionary
        let mePhone = userDic["mePhone"] as! String

        
        let parameters = [
            "mePhone": mePhone
        ]
        
        
        Alamofire.request(AppDelegate.baseURLString + "/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success:
                self.stopLoadingView()
                let userDic = response.result.value as? NSDictionary
                UserDefaults.standard.set(userDic, forKey: "USER_INFO")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "USER_INFO_CHANGE"), object: self)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
            }
            
        }
        
        
//        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
//        let mePhone = userDic!["mePhone"] as! String
//        let parameters = [
//            "mePhone": mePhone
//        ]
//        Alamofire.request(.POST, AppDelegate.baseURLString + "/login", parameters: parameters, encoding: .JSON).responseJSON { response in
//            if response.result.isSuccess {
//                let userDic = response.result.value as? NSDictionary
//                NSUserDefaults.standardUserDefaults().setObject(userDic, forKey: "USER_INFO")
//                NSNotificationCenter.defaultCenter().postNotificationName("USER_INFO_CHANGE", object: self)
//                
//                self.userInfoChange()
//            }
//        }
    }

}


// MARK: - UIImagePickerControllerDelegate
extension MeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        //
        //        }
        
        
        guard let assetURL = info[UIImagePickerControllerReferenceURL] as? NSURL else {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                print(image)
                
                
                picker.dismiss(animated: true, completion: nil)
                self.cacheUploadImageWithTake(originalImage: image)
                

            }
            return
        }
        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetURL as URL], options: nil)
        
        guard let asset = (fetchResult.firstObject as Any) as? PHAsset else {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                print(image)
            }
            return
        }
        
        self.cacheUploadImage(originalImage: asset)
        
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    /**
     *  获得指定size的图片
     *
     *  image   原始图片
     *  newSize 指定的size
     *
     *  return 调整后的图片
     */
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    
    
}

// MARK: - ImagePickerSheetControllerDelegate
extension MeController: ImagePickerSheetControllerDelegate {
    
    func controllerWillEnlargePreview(_ controller: ImagePickerSheetController) {
        print("Will enlarge the preview")
    }
    
    func controllerDidEnlargePreview(_ controller: ImagePickerSheetController) {
        print("Did enlarge the preview")
    }
    
    
    func controller(_ controller: ImagePickerSheetController, willSelectAsset asset: PHAsset) {
        print("Will select an asset")
    }
    
    func controller(_ controller: ImagePickerSheetController, didSelectAsset asset: PHAsset) {
        print("Did select an asset")
    }
    
    func controller(_ controller: ImagePickerSheetController, willDeselectAsset asset: PHAsset) {
        print("Will deselect an asset")
    }
    
    func controller(_ controller: ImagePickerSheetController, didDeselectAsset asset: PHAsset) {
        print("Did deselect an asset")
    }
    
}

