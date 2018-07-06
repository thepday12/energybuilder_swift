//
//  BaseController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/15/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import Foundation
import UIKit
let ACTION_DOWNLOAD = "ACTION_DOWNLOAD"
let ACTION_UPLOAD = "ACTION_UPLOAD"
class BaseController:UIViewController,UINavigationControllerDelegate{
    
    
    func initNavigationBar(menuRight:UIBarButtonItem){
        //action click right menu
        menuRight.target = self.revealViewController();
        menuRight.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        //Click ngoai menu phai tu dong
        if self.revealViewController() != nil {
            //Khi giu va keo cho hien ra menu phai
            self.revealViewController().panGestureRecognizer().isEnabled=true;
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    func moveHome(){
        let homeView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "home")
        self.present(homeView, animated: true, completion: {
            let navController = UINavigationController( rootViewController: self )
            navController.popToRootViewController(animated: false)
        })
    }
    
    func moveLogin(actionName:String?=""){
        let view = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login") as! LoginViewController
        view.actionName = actionName!
        
        self.present(view, animated: true, completion: nil)
    }
    
    func moveRoutes(){
       
        let view = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "routes")
        self.present(view, animated: true, completion: nil)
        
    }
    
    func handlerUpload(){
        let dataUpload = getUploadData()
        if !dataUpload.isEmpty{
            showDialogConfirm(viewController: self, title: "Warning", content: "All your offline data will replace server's data if exists. Do you really want to continue?",  handler: { (action: UIAlertAction!) in
                uploadDataHandler(viewController: self,dataUpload: dataUpload)
            })
        }
    }
    
    
}
