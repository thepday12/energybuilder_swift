//
//  DetailPointViewCell.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/18/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit
import DatePickerDialog
import DropDown

class DataCaptureViewCell: UITableViewCell {
    
    @IBOutlet weak var ivDropdown: UIImageView!
    @IBOutlet weak var viewDropdown: UIView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btValue: UIButton!
    var objectAttr = ObjectAttrs()
    @IBOutlet weak var etValue: UITextField!
   
    let dropDown = DropDown()
    var index = 0
    var indexDropdown = 0
    var type = ""
    var listValue = [ObjectNumber]()//Dung de lay danh sach du lieu da luu
    var objectData:ObjectData = ObjectData()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func createField(type:String,index:Int,objectAttr:ObjectAttrs,objectData:ObjectData){
        let objectDetails = getObjectDetail()
        self.objectData = objectData;
        self.type = type
        self.index = index
        self.objectAttr = objectAttr
        var labelValue = objectAttr.name
        if objectAttr.mandatory {
            labelValue += "(*)"
        }
        label.text = labelValue
        label.textColor = UIColor.black
          etValue.delegate = nil
        switch objectAttr.controlType {
        case "n":
            etValue.isHidden = false
            viewDropdown.isHidden = true
            etValue.isEnabled = objectAttr.enable
            etValue.keyboardType = UIKeyboardType.decimalPad
            etValue.text = objectAttr.value.formatDecimalValueWithLocation
            etValue.delegate = self
            label.textColor = UIColor.blue
//            if !objectDetails.isEmpty{
//                if let json = try? JSONSerialization.jsonObject(with: objectDetails.data(using: .utf8)!) as![String:Any]{
//                    let id = type+"_"+objectData.id
//                     listValue = [ObjectNumber]()

//                     let view = self.viewController as! DataCaptureViewController
//                    let endWith = ""
//                    for item in json{
//                        if item.key.starts(with: id) && item.key.reversed().starts(with: endWith.reversed()){
//                            let jsonValue = item.value as! [String:String]
//                            if let value = jsonValue[objectAttr.key]{
//                                var occurDate = item.key.components(separatedBy: "_")[2]
//
//                                listValue.append(ObjectNumber(value: value, occurDate:occurDate ))
//                            }
//                        }
//                    }
                    label.clickListener(myTarget: self, myAction: #selector(showDialog))
//                }
//            }
            break
        case "t":
            etValue.isHidden = false
            viewDropdown.isHidden = true
            etValue.isEnabled = objectAttr.enable
            etValue.keyboardType = .default
            etValue.text = objectAttr.value
            break
        case "d":
            viewDropdown.isHidden = false
            etValue.isHidden = true
            ivDropdown.image = #imageLiteral(resourceName: "ic_date")
            viewDropdown.setBackgroundDropdown()
            btValue.isEnabled = objectAttr.enable
            var value = getCurrentDate()
            if objectAttr.value.isEmpty{
                objectAttr.value = value
            }else{
                value = objectAttr.value
            }
            lbValue.text = value
            break
        default://l
            viewDropdown.isHidden = false
            ivDropdown.image = #imageLiteral(resourceName: "ic_dropdown")
            etValue.isHidden = true
            viewDropdown.setBackgroundDropdown()
            btValue.isEnabled = objectAttr.enable
            createViewDropdown()
            
            break
        }
    }
    
    @IBAction func btValueClick(_ sender: Any) {
        if objectAttr.controlType == "d"{
            datePickerTapped()
        }else if objectAttr.controlType == "l"{
            dropDown.show()
        }
    }
    
    
    @IBAction func changeValue(_ sender: Any) {
        updateValue()
    }
    @IBAction func endEditValue(_ sender: Any) {
        
    }
    
    func updateObjectData(objectData:ObjectData){
        objectAttr.objectData = objectData
        if objectData.listPhase.count > 0{
            objectAttr.value = objectData.listPhase[0].getPhaseCode()
        }
        createViewDropdown()
    }
    
    func createViewDropdown(){
//        listObjectVisible =  [String]()
//        let objectData =  objectAttr.objectData
//        if self.index == 1 && type == "EU"{
//            for item in objectData.listPhase{
//                listObjectVisible.append(item.getName())
//                listObject.append(ListObject(key: item.getPhaseCode(),name: item.getName()))
//            }
//
//        }else{
////            let values = listValue[objectAttr.list] as! [String:String]
//            for item in objectAttr.list{
//                listObject.append(ListObject(key: item.key, name: item.value))
//                listObjectVisible.append(item.value)
//            }
//        }
        
        dropDown.anchorView = btValue
        dropDown.dataSource  = objectAttr.listObjectVisible
        var name = ""
        var value = objectAttr.listObject[0].key
        if objectAttr.value.isEmpty{
            objectAttr.value = value
        }else{
             value = objectAttr.value
        }
      
        for item in objectAttr.listObject{
            if item.key == value {
                name = item.name
                break
            }
        }
        lbValue.text = name
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.indexDropdown = index
            self.lbValue.text = item
            self.updateValue()
            self.dropDown.hide()
            if self.index == 1 && self.type == "EU"{
                let view = self.viewController as! DataCaptureViewController
                view.loadDataFromDataObjects()
            }
        }
    }
    
    func updateValue(){
        let view = viewController as! DataCaptureViewController
        objectAttr.value = getValue()
        view.updateValue(index: index, object: objectAttr)
    }
    
    
    func getValue()->String{
        var result = ""
        switch objectAttr.controlType {
        case "n":
            if let value = etValue.text{
                result = value
            }
            break
        case "t":
            if let value = etValue.text{
                result = value
            }
            break
        case "d":
            if let value = lbValue.text{
                result = value
            }
            break
        default://l
            
            if let value = lbValue.text{
                for item in objectAttr.listObject{
                    if item.name == value {
                         result = item.key
                        break
                    }
                }
            }
            break
        }
        return result
    }
    
    func datePickerTapped() {
        DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: lbValue.text!.toDate, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = MY_DATE_FORMAT
                let dateValue = formatter.string(from: dt)
                self.lbValue.text = dateValue
                self.updateValue()
                let viewController = self.viewController as! DataCaptureViewController
                if self.index == 0{
                viewController.loadDataFromDataObjects(dateValue: dateValue)
                }
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func showDialog(){
        let objectDetail = getObjectDetail()
        if let json = try? JSONSerialization.jsonObject(with: objectDetail.data(using: .utf8)!) as![String:Any]{
            let id = type+"_"+objectData.id
            listValue = [ObjectNumber]()
            
            let view = self.viewController as! DataCaptureViewController
            let endWith = view.getEndId()
            for item in json{
                if item.key.starts(with: id) && item.key.reversed().starts(with: endWith.reversed()){
                    let jsonValue = item.value as! [String:String]
                    if let value = jsonValue[objectAttr.key]{
                        if !value.isEmpty {
                        var occurDate = item.key.components(separatedBy: "_")[2]
                            if !occurDate.isEmpty{
                                listValue.append(ObjectNumber(value: value, occurDate:occurDate ))
                            }
                        }
                    }
                }
            }
            if listValue.count > 0{
                let dialog = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dialogNumberChart") as! DialogNumberChart
                dialog.objName = label.text!
                dialog.listValue = listValue
                showViewDialog(viewController: self.viewController!, dialog: dialog, opacity: 0.75)
            }
        }
        
    }
    
}

extension DataCaptureViewCell:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}


