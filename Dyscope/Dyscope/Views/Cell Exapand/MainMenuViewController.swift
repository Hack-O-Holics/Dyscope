//
//  MainViewController.swift
//  Dyscope
//
//  Created by Shreeniket Bendre on 9/5/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //MARK:- ViewDid's
    var arr = ["toBT","toAR","toTips"]
    var rowIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- TableViewLayout
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 190
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.buttonMain.tag = indexPath.row
//        cell.buttonMain.frame.size.height = vie
//        cell.buttonMain.frame.size.width = view.frame.width
//
        cell.buttonMain.addTarget(self, action: #selector(rowButtonWasTapped(sender:)), for: .touchUpInside)
        let image = UIImage(named: "\(cell.buttonMain.tag)")
        cell.buttonMain.setBackgroundImage(image, for: .normal)
        
        return cell
    }
    
    
    //MARK:- CellSetup and ViewAnimate
    @objc fileprivate func rowButtonWasTapped(sender: UIButton){
        
        rowIndex = sender.tag
        print ("row at \(rowIndex)")
        if rowIndex != 3{
            self.animateView(sender)
        }
        else{
            tappedPortal()
        }
        
        //Call UIImage with id rowIndex
    }
    
    
    //Animate Buttons
    
    func tappedPortal(){
    let url = URL(string: "https://landing.google.com/screener/covid19")!
        let vc = SFSafariViewController(url: url)
        present (vc, animated: true)
        
    }
    
    func animateView(_ buttonAnimate :UIView){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            buttonAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                 self.performSegue(withIdentifier: "\(self.arr[self.rowIndex])", sender: self)
                buttonAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
               
            }, completion: nil)
        }
    }

    

    
}
