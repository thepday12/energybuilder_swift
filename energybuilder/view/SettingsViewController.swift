//
//  SettingsViewController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/15/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var etServer: UITextField!
    @IBOutlet weak var dataType: UISegmentedControl!
    @IBOutlet weak var etHistoryDays: UITextField!
    @IBOutlet weak var btSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let serverUrl = getServerUrl()
        if !serverUrl.isEmpty{
            etServer.text = serverUrl
        }
        dataType.selectedSegmentIndex = getDataType()
        etHistoryDays.text = getHistoryDays().stringValue
        btSave.setRadiusForButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDialogError(){
        showDialogMessage(viewController: self,title: "SAVE", message: "Can't save settings in device")
    }
    
    @IBAction func clickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSave(_ sender: Any) {
        if let serverUrl = etServer.text{
            if !serverUrl.isEmpty{
                
                var historyDays = "7"
                if  let value = etHistoryDays.text{
                    historyDays = value
                }
                if setSettings(serverUrl: serverUrl, dataType: dataType.selectedSegmentIndex, historyDays: historyDays){
                    SERVER_URL = serverUrl;
                    dismiss(animated: true, completion: nil)
                }else{
                    showDialogError()
                }
            }
        }
    }
    
}
