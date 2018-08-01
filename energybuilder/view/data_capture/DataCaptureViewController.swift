//
//  DataCaptureViewController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/18/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit
import DropDown
import Toast_Swift

class DataCaptureViewController: BaseController {
    
    @IBOutlet weak var btReset: UIButton!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewDropdown: UIView!
    @IBOutlet weak var lbValueObjectVisible: UILabel!
    @IBOutlet weak var viewShowPicker: UILabel!
    var objects = [String:Any]()
    var point = Point()
    var listObject = [ObjectData]()
    var listObjectAttr = [ObjectAttrs]()
    var listObjectVisible = [String]()
    var listValues = [String:Any]()
    var currentObjectData = ObjectData()
    
    
    var type = ""
    var typeName = ""
    var total = 0
    var selection = 0
    let dropDown = DropDown()
    
    var value = ""
    
    @IBOutlet weak var btObjectVisible: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitle()
        btReset.setRadiusForButton()
        btSave.setRadiusForButton()
        
        let jsonString = getDataConfig()
        
        let data = jsonString.data(using: .utf8)!
        
        
        //add cac thuoc tinh tu server
        if let json = try? JSONSerialization.jsonObject(with: data) as![String:Any]{
            listValues = json["lists"] as![String:Any]
            let values = json["object_attrs"] as![String:Any]
            let valuesOfType = values[type] as![[String:Any]]
            
            var listObjWithType = [String]()
            for item in point.objects{
                if item.starts(with: type){
                    listObjWithType.append(item)
                }
            }
            
            for item in listObjWithType{
                if let value = objects[item] as? [String:Any]{
                    if let item = value["name"] as? String{
                        listObject.append(ObjectData(key: item, json: value, listValues:listValues))
                        listObjectVisible.append(item)
                    }
                    
                }
            }
            
            //add Occur date
            listObjectAttr.append(ObjectAttrs(name: "Occur date", dataType: "d", controlType: "d"))
            //add Phase
            if type == "EU"{
                currentObjectData = listObject[0]
                listObjectAttr.append(ObjectAttrs(name: "Operation", dataType: "l", controlType: "l",objectData:currentObjectData))// lay list ung voi gia tri mac dinh =0
            }
            //Tao Danh Sach Field
            for i in 0..<valuesOfType.count {
                let item  = valuesOfType[i]
                let obj = ObjectAttrs(json: item,listValues:listValues)
                if !obj.controlType.isEmpty{
                    listObjectAttr.append(obj)
                }
            }
            
        }
        
        loadDataFromDataObjects()
        
        
        
        
        viewDropdown.setBackgroundDropdown()
        lbValueObjectVisible.text = listObjectVisible[0]
        
        dropDown.anchorView = viewShowPicker
        // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = listObjectVisible
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lbValueObjectVisible.text = item
            self.selection = index
            self.updateTitle()
            if self.type == "EU"{
                self.updateCellOperation(index: index)
            }
            
            self.loadDataFromDataObjects()
            
        }
        
    }
    
    /**
     Lay Du lieu da luu trong objectDetail ra. Neu khong co du lieu thi load du trong
     */
    func loadDataFromDataObjects(dateValue:String?=""){
        let dataObjects = getObjectDetail()
        //Neu co du lieu moi thuc hien load Data vao khung
        if !dataObjects.isEmpty{
            let object  = listObject[selection]
            let date = listObjectAttr[0]
            //        var listValueCreateJson = listObjectAttr
            //        //Khong lay tham so Occur date
            //        listValueCreateJson.remove(at: 0)
            if date.value.isEmpty{
                date.value = getCurrentDate()
            }
            //Tao ID
            let id = getId()
            var position = 1//khong doi tham so Occur date
            if(dateValue!.isEmpty && type=="EU"){
                position = 2//khong doi tham so Occur date va operation
            }
            //Lay du lieu tu ID
            if var json = try? JSONSerialization.jsonObject(with: dataObjects.data(using: .utf8)!) as![String:Any]{
                
                //Neu tai key ung voi ID co du lieu
                if let dataAttr = json[id] as? [String:Any]{
                    for data in dataAttr{
                        for item in listObjectAttr {
                            if item.key == data.key{
                                item.value = data.value as! String
                                break
                            }
                        }
                    }
                   
                }else{
                    clearData(from: position)
                }
                
            }else{
                clearData(from: position)
            }
//            if !(dateValue?.isEmpty)! {
//                listObjectAttr[0].value = dateValue!
//            }else{
//                listObjectAttr[0].value = getCurrentDate()
//            }
            tableView.reloadData()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func showObjectList(_ sender: Any) {
        dropDown.show()
    }
    
    func updateCellOperation(index:Int){
        let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! DataCaptureViewCell
        cell.updateObjectData(objectData: listObject[index])
    }
    
    func updateTitle(){
        navigationBar.topItem?.title = typeName + " " + (selection + 1).stringValue + "/" + total.stringValue
    }
    
    func updateValue(index:Int,object:ObjectAttrs){
        listObjectAttr[index] = object
    }
    
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeClick(_ sender: Any) {
        moveHome()
    }
    
    @IBAction func saveClick(_ sender: Any) {
       
        var listValueCreateJson = listObjectAttr
       
        
        //Tao ID De save
        let id = getId()
        //Khong lay tham so Occur date
        listValueCreateJson.remove(at: 0)
        if type == "EU"{
            //Khong lay tham so Operation
            listValueCreateJson.remove(at: 0)
        }
        //Kiem tra du lieu truoc khi save
        if dataValid(){
            var contentValue = ""
            //Lay Du lieu
            for cell in listValueCreateJson{
                if !cell.value.isEmpty{
                    contentValue += cell.getJsonValue() + ","
                }
            }
            
            //            //Xoa dau "," cuoi cung
            //            saveData = String(saveData.dropLast())
            if contentValue.isEmpty{
                return
            }
            //Hoan thanh JSon
            contentValue = "{"+contentValue+"\"editted\":\"1\"}"
            let saveData = "{\""+id+"\":"+contentValue+"}"
            let uploadData = getUploadData()
            if uploadData.isEmpty{
                saveDataUpload(data: saveData)
            }else{
                let data = uploadData.data(using: .utf8)!
                if var json = try? JSONSerialization.jsonObject(with: data) as![String:Any]{
                    
                    let dataJson = try? JSONSerialization.jsonObject(with: contentValue.data(using: .utf8)!) as![String:Any]
                    json[id] = dataJson
                    saveDataUpload(data: jsonToString(dictionary: json))
                }
            }
            saveObjectDetails(data: saveData)
        }else{
            showDialogMessage(viewController: self, title: "Warning", message: "You must fill in all of the fields (*). ")
        }
        
        
    }
    func getId()->String{
        let object  = listObject[selection]
        let date = listObjectAttr[0]
       
        
        var id = type+"_"+object.id+"_"+date.value
        if type=="EU"{
            let phase = listObjectAttr[1]
            var phaseCode = phase.value
//            for item in object.listPhase{
//                if item.getName() == phase.value{
//                    phaseCode = item.getPhaseCode()
//                    break
//                }
//            }
            if phaseCode.isEmpty{
                phaseCode = object.listPhase[0].getPhaseCode()
            }
            id += "_"+phaseCode
        }
        return id
    }
    
    func getEndId()->String{
        let object  = listObject[selection]
        if type=="EU"{
            let phase = listObjectAttr[1]
            var phaseCode = phase.value
            if phaseCode.isEmpty{
                phaseCode = object.listPhase[0].getPhaseCode()
            }
            return phaseCode
        }else{
            return ""
        }
    }
    func dataValid()->Bool{
        for item in listObjectAttr{
            if item.mandatory {
                if item.value.isBlank{
                    return false
                }
            }
        }
        return true
    }
    
    func saveDataUpload(data:String){
        if setUploadData(data: data){
            
        }else{
            showDialogErrorSaveData(viewController: self)
        }
    }
    
    func saveObjectDetails(data:String){
        //Lay Du lieu moi them dang Json
        if let json = try? JSONSerialization.jsonObject(with: data.data(using: .utf8)!) as![String:Any]{
            //Lay Du lieu ObjectDetails da luu dang Json
            let objectDetail = getObjectDetail()
            if !objectDetail.isEmpty{//Neu co du lieu thi thuc hien add them cac key moi vao
                var dataJson = try? JSONSerialization.jsonObject(with: objectDetail.data(using: .utf8)!) as![String:Any]
                for item in json{
                    dataJson![item.key] = item.value
                }
                setObjectDetail(data: jsonToString(dictionary: dataJson!))
            }else{//Neu Chua co du lieu thi du lieu moi duoc ghi luon
                setObjectDetail(data: data)
            }
            self.view.makeToast("Saved!")
            tableView.reloadData()
        }
    }
    
    
    @IBAction func resetClick(_ sender: Any) {
        clearData(from: 0)
        tableView.reloadData()
    }
    
    func clearData(from:Int){
        for i in from..<listObjectAttr.count{
            let item = listObjectAttr[i]
            if i == 0{
                item.value = getCurrentDate()
            }else if item.controlType == "l"{
                item.value = item.listObject[0].key
            }else{
                item.value = ""
            }
        }
    }
    
}

extension DataCaptureViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCaptureCell", for: indexPath) as! DataCaptureViewCell
        let index = indexPath.row
        let object  = listObjectAttr[index]
        cell.createField(type:type,index: index, objectAttr: object,objectData:listObject[selection])
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listObjectAttr.count
    }
    
    func getAllCells() -> [DataCaptureViewCell] {
        
        var cells = [DataCaptureViewCell]()
        // assuming tableView is your self.tableView defined somewhere
        for i in 0...tableView.numberOfSections-1
        {
            for j in 0...tableView.numberOfRows(inSection: i)-1
            {
                
                if let cell = tableView.cellForRow(at: IndexPath(item: j, section: i)) {
                    
                    cells.append(cell  as! DataCaptureViewCell)
                }
                
            }
        }
        return cells
    }
}
