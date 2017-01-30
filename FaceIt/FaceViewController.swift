//
//  ViewController.swift
//  FaceIt
//
//  Created by Chanh Nguyen on 1/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    // MARK: Model
    var expression = FacialExpression(
        eyes: .Closed,
        eyeBrows: .Relaxed,
        mouth: .Smirk) {
        didSet { updateUI()}
    }
    
    // MARK: View
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,
                action: #selector(FaceView.changeScale(recognizer:))
            ))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    func increaseHappiness(){
        expression.mouth = expression.mouth.happierMouth()
    }
    func decreaseHappiness(){
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private var mouthCurvatures = [
        FacialExpression.Mouth.Frown: -1.0,
        .Grin: 0.5,
        .Smile: 1.0,
        .Smirk: -0.5,
        .Neutral: 0.0
    ]
    
    private var eyeBrowTilts = [
        FacialExpression.EyeBrows.Relaxed: 0.5,
        .Furrowed: -0.5,
        .Normal: 0.0
    ]
    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    
    let instance = getFaceMVCinstanceCount()
    
}

