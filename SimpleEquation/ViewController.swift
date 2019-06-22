//
//  ViewController.swift
//  SimpleEquation
//
//  Created by Przemysław Kalawski on 19/06/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let operationQueue = OperationQueue()
    
    @IBOutlet weak var enterTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doSolve(_ sender: UIButton) {
        guard let expression = enterTextField.text else { return }
        enterTextField.text = ""
        operationQueue.addOperation {
            let score = OperationSolver.solveExpression(expression: expression)
            
            DispatchQueue.main.async {
                self.scoreLabel.text = String(score)
            }
        }
    }
}

