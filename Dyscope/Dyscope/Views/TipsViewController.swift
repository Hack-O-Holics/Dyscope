//
//  TipsViewController.swift
//  Dyscope
//
//  Created by Shreeniket Bendre on 9/5/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class TipsViewController: UIViewController, YTPlayerViewDelegate{

    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var textView: UITextView!
    
    var str = "After being exposed to the virus that causes COVID-19, it can take as few as two and as many as 14 days for symptoms to develop. Cases range from mild to critical. The average timeline from the first symptom to recovery is about 17 days, but some cases are fatal. Here's what it looks like to develop COVID-19, day by day."
    var id = "OOJqHPfG7pA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.delegate = self
        setup(id, str)

        // Do any additional setup after loading the view.
    }
    
    func setup(_ id: String, _ text: String){
        
        textView.text = text
        playerView.load(withVideoId: "\(id)", playerVars: ["playsinline":1])
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    @IBAction func b1(_ sender: Any){
        playerView.stopVideo()
        str = "After being exposed to the virus that causes COVID-19, it can take as few as two and as many as 14 days for symptoms to develop. Cases range from mild to critical. The average timeline from the first symptom to recovery is about 17 days, but some cases are fatal. Here's what it looks like to develop COVID-19, day by day."
        id = "OOJqHPfG7pA"
        setup(id, str)
        
    }
    @IBAction func b2(_ sender: Any){
        playerView.stopVideo()
        str = "As doctors, authorities and employers advise self-quarantine if you exhibit any symptoms of Coronavirus, here's a quick guide to implementing a self-isolation routine in your life. There are 6 basic things that you need to be mindful of, when under quarantine. These include limited contact even with family, and maintaining hygiene regarding clothing, bed linen, and utensils."
        id = "VwVHCa81YeI"
        setup(id, str)
    }
    @IBAction func b3(_ sender: Any){
        playerView.stopVideo()
        str = "In this simple face mask sewing video, it illustrates how to cut and sew a face mask step by step no sewing machine needed. Using the plate helped me create a simple and quick pattern. You can make a face mask at home from fabric or similar materials."
        id = "uRfhuRNua_E"
        setup(id, str)
        
    }
    @IBAction func b4(_ sender: Any){
        playerView.stopVideo()
        str = "Proper hand hygiene is the most important thing you can do to prevent the spread of germs and to protect yourself and others from illnesses. When not done carefully, germs on the fingertips, palms and thumbs, and between fingers, are often missed. This video demonstrates the World Health Organization (WHO) technique for hand-washing. Watch the video to be sure you are washing your hands thoroughly."
        id = "IisgnbMfKvI"
        setup(id, str)
    }
    @IBAction func b5(_ sender: Any){
        playerView.stopVideo()
        str = "This video will be demonstrating and diagnosing different types of cough. It is is provided for educational purposes only."
        id = "XEDg1NnOpmc"
        setup(id, str)
    }
    @IBAction func b6(_ sender: Any){
        playerView.stopVideo()
        str = "A fabric mask can act as a barrier to prevent the spread of the virus. However, it must be used correctly and always combined with other measures to protect yourself and everyone else. Here is how to wear a fabric mask safely."
        id = "9Tv2BVN_WTk"
        setup(id, str)
    }
  

    
}
