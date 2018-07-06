//
//  DetailRouteViewCell.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/18/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit

class DetailRouteViewCell: UITableViewCell {

    @IBOutlet weak var ivComplete: UIImageView!
    var point = Point()
    var objects = [String:Any]()
    
    @IBOutlet weak var btItem: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btItem.setRadiusForButton(backGroundColor: UIColor.clear.cgColor)
        
    }

    func updateView(point:Point){
        self.point = point
        btItem.setTitle(point.name,for: .normal)
        if point.complete{
            ivComplete.image = #imageLiteral(resourceName: "ic_check")
        }else{
            ivComplete.image = #imageLiteral(resourceName: "ic_uncheck")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func itemClick(_ sender: Any) {
        let view = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "points") as! PointViewController
//        view.route = route
        view.point = point
        view.objects = objects
        self.viewController?.present(view, animated: true, completion: nil)
        
    }
    
}
