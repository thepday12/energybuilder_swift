//
//  DetailRouteViewController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/18/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit

class DetailRouteViewController: BaseController {
    var route:Route = Route()
    var listPoints = [Point]()
    var objects = [String:Any]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btResetRoute: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btResetRoute.setRadiusForButton()
        if !route.key.isEmpty{
            
        }
        navigationBar.topItem?.title = route.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reload()
    }
    
    
    func reload(){
        var points = [Point]()
        listPoints = [Point]()
        let jsonString = getDataConfig()
        let data = jsonString.data(using: .utf8)!
        
        if let json = try? JSONSerialization.jsonObject(with: data) as![String:Any]{
            
            //Lay danh sach point
            let pointValues =  json["points"] as![[String:Any]]
            for item  in pointValues{
                points.append(Point(json: item))
            }
            
            for item in points{
                if item.routeId == route.id{
                    listPoints.append(item)
                }
            }
            tableView.reloadData()
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func homeClick(_ sender: Any) {
        moveHome()
    }
    
    @IBAction func resetRouteClick(_ sender: Any) {
        if listPoints.count > 0 {
            showDialogConfirm(viewController: self, title: "Warning", content: "All data of this route will be removed. Do you want to continue?",handler: { (action: UIAlertAction!) in
                for point in self.listPoints{
                    completePoint(point: point, complete: false)
                }
                self.reload()
            })
        }
    }
}

extension DetailRouteViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailRouteCell", for: indexPath) as! DetailRouteViewCell
        
        let object  = listPoints[indexPath.row]
        //        cell.btItem.setTitle(object.name,for: .normal)
        //        cell.point = object
        cell.objects = objects
        cell.updateView(point:object)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPoints.count
    }
}



