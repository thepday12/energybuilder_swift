//
//  RoutesCell.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/17/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit

class RoutesCell: UITableViewCell {
    var route:Route = Route()
    var objects = [String:Any]()
    
    @IBOutlet weak var btRoute: UIButton!
    @IBOutlet weak var lbRoute: UILabel!
    @IBOutlet weak var lbTotalPoint: UILabel!
    @IBOutlet weak var lbComplete: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btRoute.setRadiusForButton(backGroundColor: UIColor.clear.cgColor)
    }
    
    func updateView(route:Route){
        self.route = route
        lbRoute.text = route.name
        lbTotalPoint.text = "Points: "+route.total
        let percent:Int = route.complete*100/route.getIntTotal()
        lbComplete.text = "Complete: "+route.complete.stringValue+" ("+percent.stringValue+"%)"
    }

    @IBAction func btRouteClick(_ sender: Any) {
        let view = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailRoute") as! DetailRouteViewController
        view.route = route
        view.objects = objects
        self.viewController?.present(view, animated: true, completion: nil)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
