//
//  ViewController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/15/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit

let notificationMoveRoutes = "move.routes"
class ViewController: BaseController {
    
    @IBOutlet weak var btRoutes: UIButton!
    @IBOutlet weak var btDownloadConfig: UIButton!
    @IBOutlet weak var btUploadData: UIButton!
    @IBOutlet weak var btClearData: UIButton!
    @IBOutlet weak var btSetting: UIButton!
    @IBOutlet weak var btLogin: UIButton!
    var userToken  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationMoveRoutes),object: nil,queue: nil, using:handlerMoveRoutes)
        initView()
        
    }
    func handlerMoveRoutes(notification: Notification){
        moveRoutes()
    }
    
    func initView(){
        btRoutes.setRadiusForButton()
        btDownloadConfig.setRadiusForButton()
        btUploadData.setRadiusForButton()
        btClearData.setRadiusForButton()
        btSetting.setRadiusForButton()
        btLogin.setRadiusForButton()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let serverUrl = getServerUrl()
        
        if serverUrl.isEmpty{
            let view = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "settings")
            self.present(view, animated: true, completion: nil)
        }else{
            SERVER_URL = serverUrl
        }
        updateLoginButton()
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        if userToken.isEmpty{
            moveLogin()
        }else{
            if logout(){
                updateLoginButton()
            }
        }
        
    }
    
    @IBAction func clickDownloadConfig(_ sender: Any) {
        let dataConfig = getDataConfig()
        if userToken.isEmpty{
            moveLogin(actionName: ACTION_DOWNLOAD )
        }else{
            if dataConfig.isEmpty{
                downloadConfigHandler(viewController: self, isDismiss: false)
            }else{
                showDialogConfirm(viewController: self, title: "Warning", content: "All your data and configurations will be replaced",handler:{ (action: UIAlertAction!) in
                    downloadConfigHandler(viewController: self, isDismiss: false)
                })
            }
        }
    }
    
    @IBAction func btUploadClick(_ sender: Any) {
        if userToken.isEmpty{
            moveLogin(actionName: ACTION_UPLOAD )
        }else{
            handlerUpload()
            
        }
    }
    
    @IBAction func clickRoutes(_ sender: Any) {
        let dataConfig = getDataConfig()
        if userToken.isEmpty{
            moveLogin(actionName: ACTION_DOWNLOAD)
        }else{
            if dataConfig.isEmpty{
                downloadConfigHandler(viewController: self, isDismiss: false)
            }else{
                moveRoutes()
            }
        }
        
    }
    
    
    
    
    func updateLoginButton(){
        userToken = getUserToken()
        if userToken.isEmpty {
            btLogin.setTitle("LOGIN", for: .normal)
        }else{
            btLogin.setTitle("LOGOUT", for: .normal)
        }
    }
    
}

