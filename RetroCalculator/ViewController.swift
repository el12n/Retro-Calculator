//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Alvaro De La Cruz on 10/28/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String{
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    var currentOperation = Operation.Empty
    var result = ""
    var leftVal = ""
    var rightVal = ""
    var runningNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do{
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    func playSound(){
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    func processOperation(operation: Operation){
        playSound()
        if currentOperation != Operation.Empty{
            if runningNumber != "" {
                rightVal = runningNumber
                runningNumber = ""
                switch currentOperation {
                case .Divide:
                    result = "\(Double(leftVal)! / Double(rightVal)!)"
                case .Multiply:
                    result = "\(Double(leftVal)! * Double(rightVal)!)"
                case .Add:
                    result = "\(Double(leftVal)! + Double(rightVal)!)"
                case .Subtract:
                    result = "\(Double(leftVal)! - Double(rightVal)!)"
                default: break
                }
                leftVal = result
                outputLbl.text = result
            }
            currentOperation = operation
        }else{
            leftVal = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        playSound()
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDivide(_ sender: UIButton) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiply(_ sender: UIButton) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtract(_ sender: UIButton) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAdd(_ sender: UIButton) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqual(_ sender: UIButton) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClear() {
        playSound()
        runningNumber = ""
        leftVal = ""
        rightVal = ""
        result = ""
        currentOperation = Operation.Empty
        outputLbl.text = "0"
    }
}
