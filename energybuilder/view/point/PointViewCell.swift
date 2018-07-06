//
//  PointViewCell.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/18/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit

class PointViewCell: UITableViewCell {

    @IBOutlet weak var lbTotal: UILabel!
    @IBOutlet weak var btName: UIButton!
    var objects = [String:Any]()
    var point = Point()
    var type = ""
    var typeName = ""
    var total = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbTotal.setRadiusForView()
        btName.setRadiusForButton(backGroundColor: UIColor.clear.cgColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func itemClick(_ sender: Any) {
        let view = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dataCapture") as! DataCaptureViewController
        //        view.route = route
        view.point = point
        view.objects = objects
        view.total = total
        view.type = type
        view.typeName = typeName
        self.viewController?.present(view, animated: true, completion: nil)
    }
    
}
