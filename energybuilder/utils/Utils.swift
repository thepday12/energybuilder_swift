//
//  Utils.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/15/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import Foundation
import Presentr
import UIKit
let DEFAULT_VALUE_KEY = "default_value"
let SERVER_URL_KEY = "server_url"
let DATA_TYPE_KEY = "data_type"
let HISTORY_DAYS_KEY = "history_days"
let USER_TOKEN_KEY = "user_token"
let DATA_CONFIG_KEY = "data_config"
let OBJECT_DETAILS_KEY = "object_detail"
let UPLOAD_DATA_KEY = "upload_data"
let UPLOAD_DATA_OLD_KEY = "upload_data_old"
let MY_DATE_FORMAT = "yyyy-MM-dd"

func getCurrentDate()->String{
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = MY_DATE_FORMAT
    return formatter.string(from: date)
}

func jsonToString(dictionary:[String:Any])->String{
    var theJSONText = ""
    if let theJSONData = try? JSONSerialization.data(
        withJSONObject: dictionary,
        options: []) {
        theJSONText = String(data: theJSONData,
                             encoding: .utf8)!
//        print("JSON string = \(theJSONText)")
    }
    return theJSONText;
}


func showDialogErrorSaveData(viewController:UIViewController,title:String? = "Warning",dataName:String? = "data"){
    showDialogMessage(viewController: viewController,title: title!, message: "Can't save " + dataName! + " on device")
}

func jsonConvertError(viewController:UIViewController){
    showDialogMessage(viewController: viewController,title: "Error", message: "Server cannot process your request please try again later lync")
}

func showDialogMessage(viewController:UIViewController,title:String, message:String,handler:((UIAlertAction) -> Swift.Void)? = nil){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    // add the actions (buttons)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler))
    // show the alert
    viewController.present(alert, animated: true, completion: nil)
}

func showDialogConfirm(viewController:UIViewController,title:String, content:String,okLabel:String?="OK",cancelLabel:String?="Cancel",handler:((UIAlertAction) -> Swift.Void)? = nil){
    let refreshAlert = UIAlertController(title: title, message: content, preferredStyle: UIAlertControllerStyle.alert)
    
    refreshAlert.addAction(UIAlertAction(title: okLabel, style: .default, handler: handler))
    
    refreshAlert.addAction(UIAlertAction(title: cancelLabel, style: .cancel))
    
    viewController.present(refreshAlert, animated: true, completion: nil)
}
/**
 Luu thong tin settings
 - returns: *true* luu thanh cong
 - parameters:
 - serverUrl: link request api
 - dataType: FDC hoac STD
 - historyDays: So ngay mac dinh 7
 */

func setSettings(serverUrl:String,dataType:Int,historyDays:String)->Bool{
    let preferences = UserDefaults.standard
    preferences.set(serverUrl, forKey: SERVER_URL_KEY)
    preferences.set(dataType, forKey: DATA_TYPE_KEY)
    preferences.set(historyDays, forKey: HISTORY_DAYS_KEY)
    return preferences.synchronize()
}


func getServerUrl()->String{
    let preferences = UserDefaults.standard
    var result = ""
    if let value = preferences.string(forKey: SERVER_URL_KEY){
        let defaultValue = preferences.string(forKey: DEFAULT_VALUE_KEY)
        if value == defaultValue {
            return ""
        }else{
            result = value
        }
    }
    return result
}

/**
 - returns: mac dinh *FDC*
 */
func getDataType()->Int{
    let preferences = UserDefaults.standard
    return preferences.integer(forKey: DATA_TYPE_KEY)
}

func getDataTypeString()->String{
    let preferences = UserDefaults.standard
    var dt = "fdc"
    let value = preferences.integer(forKey: DATA_TYPE_KEY)
    if value == 1 {
        dt = "std"
    }
    return dt
}



/**
 - returns: mac dinh 7
 */
func getHistoryDays()->Int{
    let preferences = UserDefaults.standard
    let value = preferences.integer(forKey: HISTORY_DAYS_KEY);
    if value == 0{
        return 7;
    }
    return value
}


func setUserToken(token:String)->Bool{
    let preferences = UserDefaults.standard
    preferences.set(token, forKey: USER_TOKEN_KEY)
    return preferences.synchronize()
}


func getUserToken()->String{
    let preferences = UserDefaults.standard
    var result = ""
    if let value = preferences.string(forKey: USER_TOKEN_KEY){
        let defaultValue = preferences.string(forKey: DEFAULT_VALUE_KEY)
        if value == defaultValue {
            return ""
        }else{
            result = value
        }
    }
    return result
}

func setDataConfig(data:String,objectDetail:String)->Bool{
    let preferences = UserDefaults.standard
    preferences.set(data, forKey: DATA_CONFIG_KEY)
    preferences.set(objectDetail, forKey: OBJECT_DETAILS_KEY)
    return preferences.synchronize()
}

func setDataConfig(data:String)->Bool{
    let preferences = UserDefaults.standard
    preferences.set(data, forKey: DATA_CONFIG_KEY)
    return preferences.synchronize()
}

func getDataConfig()->String{
    let preferences = UserDefaults.standard
    var result = ""
    if let value = preferences.string(forKey: DATA_CONFIG_KEY){
        let defaultValue = preferences.string(forKey: DEFAULT_VALUE_KEY)
        if value == defaultValue {
            return ""
        }else{
            result = value
        }
    }
    return result
}

func setObjectDetail(data:String)->Bool{
    let dataConfig =  getDataConfig()
    if var json = try? JSONSerialization.jsonObject(with: dataConfig.data(using: .utf8)!) as![String:Any]{
        let dataJson = try? JSONSerialization.jsonObject(with: data.data(using: .utf8)!) as![String:Any]
        json["object_details"] = dataJson
        return setDataConfig(data: jsonToString(dictionary: json))
    }else{
        return false
    }
}


func getObjectDetail()->String{
    var result = ""
    let dataConfig =  getDataConfig()
    if var json = try? JSONSerialization.jsonObject(with: dataConfig.data(using: .utf8)!) as![String:Any]{
        
        if let data = json["object_details"]  as? [String:Any]{
            result = jsonToString(dictionary: data)
        }
    }
    return result
}


func setUploadData(data:String)->Bool{
    let preferences = UserDefaults.standard
    preferences.set(data, forKey: UPLOAD_DATA_KEY)
    return preferences.synchronize()
}


func getUploadData()->String{
    let preferences = UserDefaults.standard
    var result = ""
    if let value = preferences.string(forKey: UPLOAD_DATA_KEY){
        let defaultValue = preferences.string(forKey: DEFAULT_VALUE_KEY)
        if value == defaultValue {
            return ""
        }else{
            result = value
        }
    }
    return result
}



func logout()->Bool{
    
    let preferences = UserDefaults.standard
    //    Xoa all
    //    let domain = Bundle.main.bundleIdentifier!
    //    preferences.removePersistentDomain(forName: domain)
    //    return preferences.synchronize()
    preferences.set("", forKey: DATA_CONFIG_KEY)
    preferences.set("", forKey: USER_TOKEN_KEY)
    preferences.set("", forKey: UPLOAD_DATA_KEY)
    preferences.set("", forKey: UPLOAD_DATA_OLD_KEY)
    return preferences.synchronize()
}




func completePoint(point:Point,complete:Bool) ->Bool{
    let json = setCompletePoint(pointObj: point, complete: complete)
    if json.count > 0{
        return setDataConfig(data: jsonToString(dictionary: json))
    }else{
        return false
    }
}

func setCompletePoint(pointObj:Point,complete:Bool)->[String:Any]{
    var result = [String:Any]()
    let dataConfig =  getDataConfig()
    if var json = try? JSONSerialization.jsonObject(with: dataConfig.data(using: .utf8)!) as![String:Any]{
        //Update complete cho Points
        var points = json["points"] as! [String:Any]
        var point = points[pointObj.key] as! [String:Any]
        point ["complete"] = complete
        points[pointObj.key] = point
        json["points"] =  points
        //Update so luong complete cho Routes
        var routes = json["routes"] as! [String:Any]
        for item in routes{
            var route = item.value as! [String:Any]
            if route["id"] as! String == pointObj.routeId{
                var completeCount = 0
                for item2 in points{
                    let pt = item2.value as! [String:Any]
                    if pt["route_id"] as! String == pointObj.routeId {
                        if pt["complete"] as! Bool == true {
                            completeCount += 1
                        }
                    }
                }
                
                route["complete"] = completeCount.stringValue
                
                routes[item.key] = route
                break
            }
        }
        json["routes"] = routes
        //Neu la reset thuc hien update lai objectDetail
        if !complete {
            //update objectDetail
            let idObjectList = point["objects"] as! [String]
            let objectDetail = json["object_details"]  as![String:Any]
            var objTMP = objectDetail
            for idObject in idObjectList{
                for item in objectDetail{
                    let key = item.key
                    if key.starts(with: idObject){
                        objTMP.removeValue(forKey: key)
                    }
                }
            }
            json["object_details"] = objTMP
            //update objectDetail Upload
            if let jsonUpload = try? JSONSerialization.jsonObject(with: getUploadData().data(using: .utf8)!) as![String:Any]{
                var objTMPUpload = jsonUpload
                for idObject in idObjectList{
                    for item in jsonUpload{
                        let key = item.key
                        if key.starts(with: idObject){
                            objTMPUpload.removeValue(forKey: key)
                        }
                    }
                }
                setUploadData(data: jsonToString(dictionary: objTMPUpload))
            }
        }
        
        result = json
    }
    return result
}

func showViewDialog(viewController:UIViewController,dialog:UIViewController, opacity:Float?){
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        return presenter
    }()
    presenter.presentationType = .fullScreen
    presenter.transitionType = nil
    presenter.dismissTransitionType = nil
    
    presenter.keyboardTranslationType = .compress
    let newOpacity = opacity ?? 0.4
    presenter.backgroundOpacity = newOpacity
    viewController.customPresentViewController(presenter, viewController: dialog, animated: true, completion: nil)
}

