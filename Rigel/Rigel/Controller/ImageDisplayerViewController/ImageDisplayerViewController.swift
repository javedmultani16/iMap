//
//  ImageDisplayerViewController.swift
//  App
//
//  Created by Javed Multani on 22/10/2019.
//  Copyright © 2018 iOS. All rights reserved.
//

import UIKit

import SDWebImage
import SwiftIcons
import SwiftyJSON
import RealmSwift
import Realm
import SYPhotoBrowser

class ImageDisplayerViewController: BaseVC,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var arrayPhoto : [ObjPhoto] = [ObjPhoto]()
    var arrayPhotoURL = [String]()
    @IBOutlet weak var collectionViewGallery: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                            right_icon_Name:nil,
                                            right_action: nil,
                                            title: "Listing")
        collectionViewGallery.delegate = self
        collectionViewGallery.dataSource = self
        
        collectionViewGallery.backgroundColor = CLEAR_COLOR;
        
        let spacingCell : CGFloat = 8.0
        let cellSize : CGFloat = (SCREENWIDTH() - spacingCell*3)/2
        let collectionViewLayout: UICollectionViewFlowLayout = (collectionViewGallery!.collectionViewLayout as! UICollectionViewFlowLayout)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: spacingCell, left: spacingCell, bottom: spacingCell, right: spacingCell)
        collectionViewLayout.minimumInteritemSpacing = spacingCell
        collectionViewLayout.itemSize = CGSize(width: cellSize, height: cellSize*0.8)
        collectionViewLayout.scrollDirection = .vertical
        
        collectionViewGallery.showsHorizontalScrollIndicator = false
        collectionViewGallery.showsVerticalScrollIndicator = false
        
        collectionViewGallery.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        self.getPhotos()
        collectionViewGallery.reloadData()
       
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Colllectionview Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayPhotoURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell",for:indexPath) as! ImageCollectionViewCell
        
        let url = URL(string: self.arrayPhotoURL[indexPath.item])
        cell.imageViewGallery.sd_setImage(with: url, placeholderImage: Set_Local_Image(IMAGE_PLACEHOLDER),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            if image == nil{
                cell.imageViewGallery.image = Set_Local_Image(NO_IMAGE)
            }
        })
        //cell.setCornerRadius(radius: 3)
        cell.layer.cornerRadius = 3.0
        cell.backgroundColor = APP_WHITE_COLOR
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIDevice.current.setValue(UIInterfaceOrientationMask.portrait.rawValue, forKey: "orientation")
//        let photoArray = [self.arrayPhotoURL[indexPath.item]]
//        let photoBrowser = SYPhotoBrowser.init(imageSourceArray: photoArray, caption: nil, delegate: self)
//        photoBrowser?.initialPageIndex = 0// UInt((sender.view?.tag)!)
//        photoBrowser?.pageControlStyle = .system
//        self.present(photoBrowser!, animated: true, completion: nil)
        let imageDisplayerVC = loadVC(storyboardMain, viewGalleryVC) as! GalleryViewController
        imageDisplayerVC.arrayPhotoURL = self.arrayPhotoURL
        imageDisplayerVC.currentIndex = indexPath.item
        self.navigationController?.pushViewController(imageDisplayerVC, animated: true)
    }
    //MARK: - custom method
    
    //get Photos from flickr by api calling
    func getPhotos(){
        
        if isConnectedToNetwork() {
            
            self.createMainLoaderInView(message: "Loading...")
            let dic = ["method" :"flickr.photos.getRecent",
                       "api_key" : "6ca75262d6a4f5f58470623c87f5deec",
                       "format" : "json","nojsoncallback":"1"]
            
            let urlSignIn = "https://api.flickr.com/services/rest"
            HttpRequestManager.sharedInstance.postParameterRequest(endpointurl: urlSignIn, reqParameters: dic as NSDictionary) { (responseDic, error, message, true) in
                //print(responseDic)
                if let photosDic = responseDic!["photos"] as? [String : Any]{
                    let dataPhoto = photosDic["photo"] as! [NSArray]
                    
                    var swiftArray = dataPhoto as AnyObject as! [Any]
                
                    for i in 0..<swiftArray.count {
                        let json = JSON(swiftArray[i])
                        let objPhoto : ObjPhoto = ObjPhoto.init(json: json)
                        self.arrayPhoto.append(objPhoto)
                        let strPhoto = self.getPrepareString(farmId: objPhoto.farm!, serverId: objPhoto.server!, id: objPhoto.id!, secret: objPhoto.secret!)
                        self.arrayPhotoURL.append(strPhoto)
                        
                    }
                    self.collectionViewGallery.reloadData()
                    self.stopLoaderAnimation(vc: self)
                    
                }
            }
        }
    }
    //Prepare string for flickr photo load
    public func getPrepareString(farmId:Int, serverId:String,id:String,secret:String) -> String{
        let strPrepare = "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret).jpg"
        return strPrepare
    }
}
