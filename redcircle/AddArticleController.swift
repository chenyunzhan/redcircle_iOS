//
//  AddArticleController.swift
//  redcircle
//
//  Created by zhan on 16/11/29.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import SnapKit
import ImagePickerSheetController
import Photos
import Alamofire

class AddArticleController: BaseViewController, UITextViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var imageData : [String]?
    var originalImageArray : [String]?
    var thumbnailImageArray : [String]?
    var scrollView: UIScrollView!
    var textView: UITextView!
    var collectionView: UICollectionView!

    var  heightConstraint: Constraint?

    //声明一个闭包
    var myClosure:sendValueClosure?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func initWithClosure(closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }
    
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "发表心情"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(AddArticleController.addArticle))
        
        imageData = ["add_article"]
        originalImageArray = []
        thumbnailImageArray = []
        
        scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: self.view.frame.height, height: 300)
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        
        
        textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.text = "分享您的喜怒哀乐..."
        textView.delegate = self
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init());
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CommandCell")
        collectionView.backgroundColor = UIColor.clear
        
        scrollView.addSubview(textView)
        scrollView.addSubview(collectionView)
        
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(72)
            make.leading.equalTo(self.view).offset(8)
            make.trailing.equalTo(self.view).offset(-8)
            make.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.leading.equalTo(self.view).offset(8)
            make.trailing.equalTo(self.view).offset(-8)
            heightConstraint = make.height.equalTo(300).constraint
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.imageData?.count)!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identify:String = "CommandCell"
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identify, for: indexPath) as UICollectionViewCell
        
        
        let imageView = UIImageView()
        
        let addImage = self.imageData![indexPath.row]
        
        if indexPath.row == (self.imageData?.count)!-1 {
            imageView.image = UIImage(named: addImage)
        } else {
            imageView.image = UIImage(contentsOfFile: addImage)
        }
        
        
        cell.contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(cell.contentView).inset(UIEdgeInsetsMake(2, 2, 2, 2))
        }
        
        
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == (self.imageData?.count)!-1 {
            self.pickPhoto()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            for index in 0...numberOfPhotos-1 {
                let originalImage = controller.selectedAssets[index];
                let option = PHContentEditingInputRequestOptions()
                originalImage.requestContentEditingInput(with: option, completionHandler: { (contentEditingInput, info) -> Void in
                    let imageURL = contentEditingInput?.fullSizeImageURL
                    print(imageURL!)
                })
                
                
                let options = PHImageRequestOptions()
                options.resizeMode = PHImageRequestOptionsResizeMode.exact
                options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
                options.isSynchronous = true
                PHImageManager.default().requestImage(for: originalImage, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    print(image!)
                    let randomUnique = UtilManager.randomString(len: 32)
                    let filePath:String = NSHomeDirectory() + "/Documents/" + randomUnique + ".png"
                    let data:NSData = UIImagePNGRepresentation(image!)! as NSData
                    data.write(toFile: filePath, atomically: true)
                    self.originalImageArray?.append(filePath)
                })
                
                
                PHImageManager.default().requestImage(for: originalImage, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    print(image!)
                    let randomUnique = UtilManager.randomString(len: 32)
                    let filePath:String = NSHomeDirectory() + "/Documents/" + randomUnique + ".png"
                    let data:NSData = UIImagePNGRepresentation(image!)! as NSData
                    data.write(toFile: filePath, atomically: true)
                    self.thumbnailImageArray?.append(filePath)
                    self.imageData?.insert(filePath, at: 0)
                })
            }
            
            self.collectionView.reloadData()

            
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
    
    func addArticle() -> Void {
        
        self.startLoadingView()
        
        
        let userDic = UserDefaults.standard.dictionary(forKey: "USER_INFO")
        let mePhone = userDic?["mePhone"] as! String
        let content = self.textView.text as String
        
        sessionManager.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(mePhone.data(using: String.Encoding.utf8)!, withName: "mePhone")
                    multipartFormData.append(content.data(using: String.Encoding.utf8)!, withName: "content")
                    
                    
                    
                    for index in 0..<(self.thumbnailImageArray?.count)! {
                        let fileStr = self.originalImageArray![index]
                        let fileURL = NSURL(fileURLWithPath: fileStr)
                        let thumbnailFileStr = self.thumbnailImageArray![index]
                        let thumbnailFileURL = NSURL(fileURLWithPath: thumbnailFileStr)
                        multipartFormData.append(fileURL as URL, withName: "sourceList")
                        multipartFormData.append(thumbnailFileURL as URL, withName: "thumbList")
                    }
            },
                to: AppDelegate.baseURLString + "/addArticle",
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            self.stopLoadingView()

                            _ = self.navigationController?.popViewController(animated: true)
                            
                            //判空
                            if (self.myClosure != nil){
                                //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                                self.myClosure!("发布成功")
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
            }
        )
        
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



// MARK: - UIImagePickerControllerDelegate
extension AddArticleController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ImagePickerSheetControllerDelegate
extension AddArticleController: ImagePickerSheetControllerDelegate {
    
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
