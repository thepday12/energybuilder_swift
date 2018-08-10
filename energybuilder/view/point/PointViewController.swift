//
//  PointViewController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/18/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit
import Toast_Swift

class PointViewController: BaseController {
    var point = Point()
    var objects = [String:Any]()
    @IBOutlet weak var btComplete: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var btReset: UIButton!
    var dataCapture = [TotalDataCapture]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if point.fl.total>0{
            dataCapture.append(point.fl)
        }
        if point.eu.total>0{
            dataCapture.append(point.eu)
        }
        if point.ta.total>0{
            dataCapture.append(point.ta)
        }
        if point.eq.total>0{
            dataCapture.append(point.eq)
        }
        navigationBar.topItem?.title =  point.name
        btComplete.setRadiusForButton()
        btReset.setRadiusForButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func completeClick(_ sender: Any) {
        
        showDialogConfirm(viewController: self, title: "Point", content: "Are you sure you want to complete?",handler:{ (action: UIAlertAction!) in
            if completePoint(point: self.point, complete: true){
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationPointComplete), object: nil, userInfo: nil)
                })
            }else{
                showDialogErrorSaveData(viewController: self)
            }
        })
       
        
    }
    
    @IBAction func resetPointClick(_ sender: Any) {
        showDialogConfirm(viewController: self, title: "Warning", content: "All data of this point will be removed. Do you really want to continue?",handler: { (action: UIAlertAction!) in
            if completePoint(point: self.point, complete: false){
                showDialogMessage(viewController: self, title: "Point", message: "Point reset")
            }else{
                showDialogErrorSaveData(viewController: self)
            }
        })
        
        
        
    }
    
    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeClick(_ sender: Any) {
        moveHome()
    }
}

extension PointViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointCell", for: indexPath) as! PointViewCell
        
        let object  = dataCapture[indexPath.row]
        cell.btName.setTitle(object.name,for: .normal)
        cell.lbTotal.text = object.total.stringValue
        cell.type = object.type
        cell.typeName = object.name
        cell.total = object.total
        cell.objects = objects
        cell.point = point
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCapture.count
    }
}
