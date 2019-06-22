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
        enterTextField.delegate = self
    }
    
    @IBAction func doSolve(_ sender: UIButton) {
        guard let expression = enterTextField.text else { return }
        operationSolver.solve(expression)
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

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string == " " ? false : true
    }
}
