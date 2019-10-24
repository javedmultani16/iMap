//
//  GalleryViewController.swift
//  Rigel
//
//  Created by Javed Multani on 22/10/2019.
//  Copyright © 2019 Javed Multani. All rights reserved.
//

import UIKit

import SDWebImage
import SwiftIcons
import SwiftyJSON
class GalleryViewController: BaseVC {
   var arrayPhotoURL = [String]()
    var currentIndex = 0
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                            right_icon_Name:nil,
                                            right_action: nil,
                                            title: "Gallery")
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    func updateUI(){
        self.createMainLoaderInView(message: "Loading")
        let url = URL(string: self.arrayPhotoURL[currentIndex])
        self.imageView.sd_setImage(with: url, placeholderImage: Set_Local_Image(IMAGE_PLACEHOLDER),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            self.stopLoaderAnimation(vc: self)
            if image == nil{
                self.imageView.image = Set_Local_Image(NO_IMAGE)
            }
        })
        
    }
    @IBAction func buttonHandlerPre(_ sender: Any) {
        currentIndex = currentIndex - 1
        if currentIndex < 0{
            currentIndex = currentIndex + 1
        }else{
            
            self.updateUI()
        }
        
    }
    @IBAction func buttonHandlerNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        if currentIndex == self.arrayPhotoURL.count{
            currentIndex = currentIndex - 1
        }else{
        //currentIndex = currentIndex + 1
        self.updateUI()
        }
    }
    @IBAction func buttonHandlerDownload(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
      
    }
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image downloaded successfully...", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
}
