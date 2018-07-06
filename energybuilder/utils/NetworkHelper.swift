//
//  NetworkHelper.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/16/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import Foundation
import Alamofire
var SERVER_URL = ""

func buildIndicator(view:UIView) -> UIActivityIndicatorView{
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    indicator.color = UIColor(hex: UIColor.colorPrimary)
    indicator.frame = CGRect.init(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    indicator.center = view.center
    return indicator
    
}

func completeLoading(viewController:UIViewController,indicator:UIActivityIndicatorView){
    indicator.stopAnimating()
    viewController.view.isUserInteractionEnabled = true
}
func connectionErrorDialog(viewController:UIViewController){
    showDialogMessage(viewController: viewController,title: "Connection", message: "Can't connect to server")
}

func loginHandler(viewController:BaseController,userName:String, password:String, actionName:String){
    let view  = viewController.view!
    let linkAPI = SERVER_URL + "/dclogin"
    
    let indicator = buildIndicator(view:view)
    view.addSubview(indicator)
    viewController.view.isUserInteractionEnabled = false
    indicator.startAnimating()
    let parameters: Parameters = [
        "username": userName,
        "password": password
        
    ]
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async { // 1
        
        Alamofire.request(linkAPI, method: .post,parameters: parameters )
            
            .responseString { response in
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value{
                        let data = jsonString.data(using: .utf8)!
                        
                        if let json = try? JSONSerialization.jsonObject(with: data) as![String:Any]{
                            let message = json["message"] as! String
                            if message == "ok"{
                                let token = json["access_token"] as! String
                                completeLoading(viewController:viewController,indicator:indicator)
                                
                                if setUserToken(token: token){
                                    switch actionName{
                                    case ACTION_DOWNLOAD:
                                        downloadConfigHandler(viewController: viewController,isDismiss: true)
                                        break
                                    case ACTION_UPLOAD:
                                        viewController.handlerUpload()
                                        break
                                    default:
                                        viewController.dismiss(animated: true, completion: nil)
                                        break
                                    }
                                    
                                }else{
                                    showDialogErrorSaveData(viewController: viewController, title: "Login", dataName: "user token")
                                }
                            }else{
                                completeLoading(viewController:viewController,indicator:indicator)
                                showDialogMessage(viewController: viewController,title: "Login", message: message)
                            }
                            
                        }else{
                            completeLoading(viewController:viewController,indicator:indicator)
                            jsonConvertError(viewController: viewController)
                        }
                    }
                    break
                case .failure(_):
                    completeLoading(viewController:viewController,indicator:indicator)
                    connectionErrorDialog(viewController: viewController)
                }
        }
    }
}

func downloadConfigHandler(viewController:BaseController, isDismiss:Bool){
    let view  = viewController.view!
    let linkAPI = SERVER_URL + "/dcloadconfig"
    
    let indicator = buildIndicator(view:view)
    view.addSubview(indicator)
    viewController.view.isUserInteractionEnabled = false
    indicator.startAnimating()
    
    let parameters: Parameters = [
        "token": getUserToken(),
        "data_type": getDataTypeString(),
        "days": getHistoryDays()
        
    ]
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async { // 1
        
        Alamofire.request(linkAPI, method: .post,parameters: parameters )
            
            .responseString { response in
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value{
                        let data = jsonString.data(using: .utf8)!
                        
                        if let json = try? JSONSerialization.jsonObject(with: data) as![String:Any]{
                            if let message = json["message"] as? String{
                                if message == "Unauthorized"{
                                    completeLoading(viewController:viewController,indicator:indicator)
                                    logout()
                                    if  viewController is LoginViewController {
                                        showDialogMessage(viewController: viewController,title: "Warning", message: message)
                                    }else{
                                        viewController.moveLogin(actionName: ACTION_DOWNLOAD)
                                    }
                                }
                            }else{
                                
                                var objectDetail = ""
                                if let value = json["object_details"] as? [String:Any] {
                                    objectDetail = jsonToString(dictionary:value )
                                }
                                if setDataConfig(data: jsonString,objectDetail:objectDetail){
                                    completeLoading(viewController:viewController,indicator:indicator)
                                    if isDismiss{
                                        viewController.dismiss(animated: true, completion: ({
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationMoveRoutes), object: nil, userInfo: nil)
                                        })
                                        )
                                    }else{
                                        viewController.moveRoutes()
                                    }
                                }else{
                                    showDialogErrorSaveData(viewController: viewController,title: "Download Configurations")
                                }
                            }
                        }else{
                            completeLoading(viewController:viewController,indicator:indicator)
                            jsonConvertError(viewController:viewController)
                        }
                        
                        
                    }
                    break
                case .failure(_):
                    completeLoading(viewController:viewController,indicator:indicator)
                    connectionErrorDialog(viewController: viewController)
                }
        }
    }
}

func uploadDataHandler(viewController:BaseController,dataUpload:String, isDismiss:Bool?=false){
    //    let dataUpload = getUploadData()
    //    if dataUpload.isEmpty{//Khong co du lieu bi thay doi
    //        if viewController is LoginViewController {
    //            viewController.dismiss(animated: true, completion: nil)
    //        }
    //    }else{
    let view  = viewController.view!
    let linkAPI = SERVER_URL + "/dcsavedata"
    
    let indicator = buildIndicator(view:view)
    view.addSubview(indicator)
    viewController.view.isUserInteractionEnabled = false
    indicator.startAnimating()
    
    let parameters: Parameters = [
        "token": getUserToken(),
        "data_type": getDataTypeString(),
        "object_details": dataUpload
    ]
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async { // 1
        
        Alamofire.request(linkAPI, method: .post,parameters: parameters )
            
            .responseString { response in
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value{
                        let data = jsonString.data(using: .utf8)!
                        if let json = try? JSONSerialization.jsonObject(with: data) as![String:Any]{
                            let message = json["message"] as! String
                            if message == "ok"{
                                setUploadData(data: "")
                                completeLoading(viewController:viewController,indicator:indicator)
                                if isDismiss!{
                                    viewController.dismiss(animated: true, completion: nil)
                                }
                            } else if message == "Unauthorized"{
                                completeLoading(viewController:viewController,indicator:indicator)
                                logout()
                                if  viewController is LoginViewController {
                                    showDialogMessage(viewController: viewController,title: "Warning", message: message)
                                }else{
                                    viewController.moveLogin()
                                }
                                
                            }
                            else{
                                completeLoading(viewController:viewController,indicator:indicator)
                                showDialogMessage(viewController: viewController,title: "Upload", message: message)
                            }
                        }else{
                            completeLoading(viewController:viewController,indicator:indicator)
                            jsonConvertError(viewController:viewController)
                        }
                        
                    }
                    break
                case .failure(_):
                    completeLoading(viewController:viewController,indicator:indicator)
                    connectionErrorDialog(viewController: viewController)
                }
        }
        //        }
    }
}


