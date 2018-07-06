//
//  LoginViewController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/16/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit


class LoginViewController: BaseController {
    
    @IBOutlet weak var etUserName: UITextField!
    @IBOutlet weak var etPassword: UITextField!
    @IBOutlet weak var btLogin: UIButton!
    var actionName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btLogin.setRadiusForButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        if let userName = etUserName.text, let password = etPassword.text{
            if !userName.isEmpty && !password.isEmpty{
                loginHandler(viewController: self, userName: userName, password: password,actionName:actionName)
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
