//
//  LoginViewController.swift
//  Dyscope
//
//  Created by Shreeniket Bendre on 9/5/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.passField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.name.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}

extension UITextField {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
