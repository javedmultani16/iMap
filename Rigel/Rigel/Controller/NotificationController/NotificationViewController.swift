//
//  NotificationViewController.swift
//  Rigel
//
//  Created by Javed Multani on 22/10/2019.
//  Copyright © 2019 Javed Multani. All rights reserved.
//

import UIKit
import CoreData
import SwiftIcons
import SwiftyJSON

class NotificationViewController: BaseVC,UITableViewDelegate,UITableViewDataSource {
    let titleArray = ["Hey, grab the offer 50% off.Visit store today","Buy1 and Get1 FREE hurry...","Checkout for free shipping","Browse these HOT offers on Bomber Jackets!"]
    let descArray = ["Visit store today & get Offer","FREE FREE FREE FREE","Delivery Free for Levis jeans"," Bomber Jackets is booming"]
    
    @IBOutlet weak var notificatiionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                            right_icon_Name:nil,
                                            right_action: nil,
                                            title: "Notifications")
        
        notificatiionTableView.delegate = self
        notificatiionTableView.dataSource = self
        notificatiionTableView.register(UINib(nibName: "NotifiacationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifiacationTableViewCell")
        // Do any additional setup after loading the view.
    }
     // MARK: - CoreData operations
    func storeInCoreData(){
        self.clearCache()
        runOnAfterTime(afterTime: 1.0) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            for i in 0 ..< self.titleArray.count{
                let entity = NSEntityDescription.entity(forEntityName:"Notification", in: context)
                let newObj = NSManagedObject(entity: entity!, insertInto: context)
                newObj.setValue(self.titleArray[i], forKey:"title")
                newObj.setValue(self.descArray[i], forKey:"desc")
                // newObj.setValue(Int(year.percentage!), forKey:"percentage")
                
            }
            
            do{
                try context.save()
                
                print("Data added successfully....")
            }catch{
                print("Error while inserting data....")
            }
        }
        
    }
    
    func clearCache(){
        self.deleteAllNotification()
        
    }
    
    func deleteAllNotification(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notification")
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in Notification error : \(error) \(error.userInfo)")
        }
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titleArray.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifiacationTableViewCell", for: indexPath) as! NotifiacationTableViewCell
        
        cell.titleLabel.text = self.titleArray[indexPath.row]
        cell.descLabel.text = self.descArray[indexPath.row]
       // cell.contentView.backgroundColor = UIColor .clear
        cell.backgroundColor = UIColor .clear
        cell.selectionStyle = .none
        
        return cell
        
    }
    

    
}
