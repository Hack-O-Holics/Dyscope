//
//  MeasureViewController.swift
//  Dyscope
//
//  Created by Shreeniket Bendre on 9/5/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class MeasureViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label:UILabel!
    var currentNodesNum : Int = 1
    var dotNodes = [SCNNode]()
    var lineNodes = [SCNNode]()
    var labels = [UILabel]()
    var lengths = [Float]()
    var line_node : SCNNode?
    var startNode : SCNNode? = nil
    var continueFlag : Bool = true
    let synthesizer = AVSpeechSynthesizer()
    var ot:Float = 0
    var pn = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        if let hitPosition = doHitTest() {
            addDot(at: hitPosition)
        }
        //continueFlag = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    func placeLabel(dot1 : SCNNode, dot2 : SCNNode) {
        let midPoint = SCNVector3(x: (dot1.position.x+dot2.position.x)/2,
                                  y: (dot1.position.y+dot2.position.y)/2,
                                  z: (dot1.position.z+dot2.position.z)/2)
        
        let setlocation = self.sceneView.projectPoint(midPoint)
        
        let firstLocation = self.sceneView.projectPoint(SCNVector3(x: dot1.position.x,
                                                                   y: dot1.position.y,
                                                                   z: dot1.position.z))
        
        let secondLocation = self.sceneView.projectPoint(SCNVector3(x: dot2.position.x,
                                                                    y: dot2.position.y,
                                                                    z: dot2.position.z))
        
        var angle : Double = 0
        angle = (firstLocation.y > secondLocation.y) ? Double(atan2(secondLocation.y - firstLocation.y, secondLocation.x - firstLocation.x)) : Double(atan2(firstLocation.y - secondLocation.y, firstLocation.x - secondLocation.x))
        //print(angle)
        
        
        let feet = (calculate(dot1 : dot1, dot2 : dot2))/30.48
        
        label.text = "\(feet) feet"
        
        
        if (feet != ot && !synthesizer.isSpeaking){
            ot = feet
            if(feet<6 && feet>=3 && pn != 1){
                pn = 1
                let utterance = AVSpeechUtterance(string: "You have measured between 3 and 6 feet. Although this is acceptable social distancing by some sources, it may be beneficial to increase distance.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-UK")
                utterance.rate = 0.6
                
                synthesizer.speak(utterance)
            }
            else if (feet<3 && pn != 2){
                pn = 2
                let utterance = AVSpeechUtterance(string: "You have measured less than 3 feet. This is a very small distance, which is not acceptable for social distancing. Please increase space.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-UK")
                utterance.rate = 0.6
                
                
                synthesizer.speak(utterance)
            }
            else if (feet>6 && pn != 3){
                pn = 3
                let utterance = AVSpeechUtterance(string: "You have measured 6 feet or more. This is proper social distancing. Keep in mind, if you have the space, more distance cannot hurt.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-UK")
                utterance.rate = 0.6
                
                
                synthesizer.speak(utterance)
            }
        }
        
        
        //label.transform = (angle < -1) ? CGAffineTransform(rotationAngle: CGFloat(angle + Double.pi)) : CGAffineTransform(rotationAngle: CGFloat(angle))
        
    }
    
    // calculate the distance between two dots
    func calculate(dot1 : SCNNode, dot2 : SCNNode) -> Float {
        let length = sqrt(pow(abs(dot1.position.x-dot2.position.x),2)+pow(abs(dot1.position.y-dot2.position.y),2)+pow(abs(dot1.position.z-dot2.position.z),2))
        let finalLength = length*100
        return finalLength
    }
    
    // do hitTest from a default position in the center
    func doHitTest() -> SCNVector3? {
        let dotLocation = CGPoint(x: UIScreen.main.bounds.size.width*0.5,y: UIScreen.main.bounds.size.height*0.5-50)
        let results = sceneView.hitTest(dotLocation, types: .featurePoint)
        if let hitPoint = results.first {
            let hitResult = self.positionTransform(transform: hitPoint.worldTransform)
            return hitResult
        }
        return nil
    }
    
    // render a dot
    func addDot(at hitResult : SCNVector3) {
        let dotGeometry = SCNSphere(radius: 0.002)
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.white
        dotGeometry.materials = [material]
        
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(x: hitResult.x, y: hitResult.y, z: hitResult.z)
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
    }
    
    // some shit for line rendering
    func positionTransform (transform : matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    // line rendering
    func drawLine(from pos1 : SCNVector3, to pos2 : SCNVector3) -> SCNNode {
        let line = lineFrom(vector : pos1, toVector : pos2)
        let lineInBetween = SCNNode(geometry : line)
        return lineInBetween
    }
    
    // line rendering
    func lineFrom(vector vector1 : SCNVector3, toVector vector2 : SCNVector3) -> SCNGeometry {
        let indices : [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            //self.label?.removeFromSuperview()
            for i in self.labels {
                i.removeFromSuperview()
            }
            
            if self.dotNodes.count != 0 && self.continueFlag != false {
                self.startNode = self.dotNodes[self.currentNodesNum-1]
            } else {
                self.startNode = nil
                self.updateLabelPosition()
                self.line_node?.removeFromParentNode()
            }
            
            if self.startNode != nil {
                guard let currentPosition = self.doHitTest(),
                    let start = self.startNode else {
                        return
                }
                
                if self.dotNodes.count > self.currentNodesNum {
                    print("dots updated")
                    self.currentNodesNum = self.dotNodes.count
                    self.lineNodes.append(self.line_node!)
                    self.placeLabel(dot1: self.dotNodes[self.currentNodesNum-2], dot2: self.dotNodes[self.currentNodesNum-1])
                    //print("new label created")
                    self.sceneView.scene.rootNode.addChildNode(self.lineNodes[self.currentNodesNum-2])
                    //print(self.labels)
                } else {
                    self.line_node?.removeFromParentNode()
                }
                
                self.updateLabelPosition()
                
                self.line_node = self.drawLine(from : currentPosition, to : start.position)
                self.sceneView.scene.rootNode.addChildNode(self.line_node!)
            }
        }
    }
    
    // update the label position
    func updateLabelPosition() {
        if currentNodesNum >= 2 {
            for i in stride(from: 2, to: currentNodesNum+1, by: 1){
                self.placeLabel(dot1: dotNodes[i-2], dot2: dotNodes[i-1])
            }
        }
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        let configuration = ARWorldTrackingConfiguration()
        
        currentNodesNum = 1
        startNode = nil
        continueFlag = true
        
        if !dotNodes.isEmpty {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
        }
        
        if !lineNodes.isEmpty {
            for line in lineNodes {
                line.removeFromParentNode()
            }
        }
        
        if !labels.isEmpty {
            for label in labels {
                label.removeFromSuperview()
            }
        }
        
        
        if line_node != nil {
            line_node?.removeFromParentNode()
        }
        
        dotNodes.removeAll()
        labels.removeAll()
        lineNodes.removeAll()
        lengths.removeAll()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
