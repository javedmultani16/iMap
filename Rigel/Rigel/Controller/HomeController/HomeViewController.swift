//
//  ViewController.swift
//  Rigel
//
//  Created by Javed Multani on 22/10/2019.
//  Copyright © 2019 Javed Multani. All rights reserved.
//

import UIKit

class HomeViewController: BaseVC {

    @IBOutlet weak var buttonLidt: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    @IBOutlet weak var buttonMap: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonMap.clipsToBounds = true
        self.buttonMap.layer.cornerRadius = 10.0
       
        self.buttonNotification.clipsToBounds = true
        self.buttonNotification.layer.cornerRadius = 10.0
        
        self.buttonLidt.clipsToBounds = true
        self.buttonLidt.layer.cornerRadius = 10.0
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden (true, animated: false)
    }
    //MARK: - button action

    @IBAction func buttonHandlerMap(_ sender: Any) {
        let imageDisplayerVC = loadVC(storyboardMain, viewVC) as! ViewController
        self.navigationController?.pushViewController(imageDisplayerVC, animated: true)
    }
    @IBAction func buttonHandlerNotification(_ sender: Any) {
        let imageDisplayerVC = loadVC(storyboardMain, viewNotificationVC) as! NotificationViewController
        self.navigationController?.pushViewController(imageDisplayerVC, animated: true)
    }
    
    @IBAction func buttonHandlerListing(_ sender: Any) {
        
        let imageDisplayerVC = loadVC(storyboardMain, viewImageDisplayerVC) as! ImageDisplayerViewController
        self.navigationController?.pushViewController(imageDisplayerVC, animated: true)
        
    }
}

