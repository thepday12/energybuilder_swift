//
//  RoutesViewController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/15/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit

class RoutesViewController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuRight: UIBarButtonItem!
    var routes = [Route]()
    var objects = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        routes = [Route]()
        objects = [String:Any]()
        
        let jsonString = getDataConfig()
        
        let data = jsonString.data(using: .utf8)!
        
        if let json = try? JSONSerialization.jsonObject(with: data) as![String:Any]{
            let values = json["routes"] as![String:Any]
            for item  in values{
                let jsonRoute = item.value as! [String:Any]
                if jsonRoute["total"] as! String != "0"{
                    routes.append(Route(key:item.key,json: jsonRoute))
                }
            }
            objects =  json["objects"] as![String:Any]
        }
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func homeClick(_ sender: Any) {
        moveHome()
    }
    @IBAction func clickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RoutesViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routesCell", for: indexPath) as! RoutesCell
    
        let object  = routes[indexPath.row]
       
        cell.updateView(route:object)
        cell.objects = objects
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
}

