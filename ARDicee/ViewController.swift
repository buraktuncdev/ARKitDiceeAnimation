//
//  ViewController.swift
//  ARDicee
//
//  Created by Burak Tunc on 7.08.2020.
//  Copyright © 2020 Burak Tunç. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        let sphere = SCNSphere(radius: 0.1)
//        let sphere2 = SCNSphere(radius: 0.2)
//
//        //let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let material = SCNMaterial()
//        let material2 = SCNMaterial()
//
//        //material.diffuse.contents = UIColor.red
//
//        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
//        material2.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
//
//        sphere.materials = [material]
//        sphere2.materials = [material2]
//
//        let node2 = SCNNode()
//        node2.position = SCNVector3(0.4,0.4,-0.5)
//        node2.geometry = sphere2
//
//
//        let node = SCNNode()
//        node.position = SCNVector3(0, 0.1, -0.5)
//        node.geometry = sphere
//        sceneView.scene.rootNode.addChildNode(node)
//        sceneView.scene.rootNode.addChildNode(node2)
        
        sceneView.autoenablesDefaultLighting = true
        
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")
//
//        if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode?.position = SCNVector3(0, 0, -0.1)
//
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
//
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("Work Tracking Supported = \(ARWorldTrackingConfiguration.isSupported)")
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {

                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!

                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {

                    diceNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        z: hitResult.worldTransform.columns.3.z
                    )

                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
                    //        let randomY = Double((arc4random_uniform(10) + 11)) * (Double.pi/2)
                    let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
                    
                    diceNode.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))

                }
                
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            
            print("plane detected")
            
            let planeAnchor = anchor as! ARPlaneAnchor

            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            let planeNode = SCNNode()

            planeNode.geometry = plane
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
        
        //guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
