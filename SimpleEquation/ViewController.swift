//
//  ViewController.swift
//  SimpleEquation
//
//  Created by Przemysław Kalawski on 19/06/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    
    @IBOutlet weak var enterTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var scoreStackView: UIStackView!
    
    let operationSolver = OperationSolver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        operationSolver.delegate = self
    }
    
    @IBAction func doSolve(_ sender: UIButton) {
        guard let expression = enterTextField.text else { return }
        operationSolver.solve(expression)
    }
    
    
    @IBAction func addNumber(_ sender: UIButton) {
        addLetterToExpression(String(sender.tag))
    }
    
    @IBAction func addParenthesis(_ sender: UIButton) {
        switch sender.tag {
        case 15:
            addLetterToExpression("(")
        case 16:
            addLetterToExpression(")")
        default:
            return
        }
    }
    
    
    @IBAction func addOperation(_ sender: UIButton) {
        switch sender.tag {
        case 11:
            addLetterToExpression("+")
        case 12:
            addLetterToExpression("-")
        case 13:
            addLetterToExpression("*")
        case 14:
            addLetterToExpression("/")
        default:
            return
        }
    }
    
    
    @IBAction func doClear(_ sender: UIButton) {
        enterTextField.text = ""
    }
    
    private func addLetterToExpression(_ letter: String) {
        guard let text = enterTextField.text else {
            enterTextField.text = letter
            return
        }
        enterTextField.text = text + letter
    }
    
}

extension ViewController: OperationDelegate {
    func solvedExpression(_ score: Double, _ error: Error?) {
        if score == 0 && error != nil {
            guard let operationError = error as? OperationError else { return }
            DispatchQueue.main.async {
                self.errorLabel.text = operationError.errorDescription!
                self.scoreLabel.text = ""
                self.scoreStackView.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
        else {
            DispatchQueue.main.async {
                self.scoreStackView.isHidden = false
                self.errorLabel.text = ""
                self.scoreLabel.text = String(score)
                self.view.layoutIfNeeded()
            }
        }
    }
}
