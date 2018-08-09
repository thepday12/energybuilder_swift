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
    @IBOutlet weak var checkBoxRemember: UIButton!
    @IBOutlet weak var btLogin: UIButton!
    var actionName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btLogin.setRadiusForButton()
        let userName = getUserName()
        
        checkBoxRemember.isSelected = !userName.isEmpty
       
        etUserName.text = userName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rememberClick(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
//            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        }) { (success) in
//            sender.isSelected = !sender.isSelected
//            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
//                sender.transform = .identity
//            }, completion: nil)
//        }
         sender.isSelected = !sender.isSelected
    }
    @IBAction func clickLogin(_ sender: Any) {
        if let userName = etUserName.text, let password = etPassword.text{
            if checkBoxRemember.isSelected {
                setUserName(data: userName)
            }else{
                setUserName(data: "")
            }
            if !userName.isEmpty && !password.isEmpty{
                loginHandler(viewController: self, userName: userName, password: password,actionName:actionName)
            }else{
                self.view.makeToast("Please enter your username and password")
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
