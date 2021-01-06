//
//  ViewController.swift
//  NavitimeApiPractice
//
//  Created by 肥沼英里 on 2021/01/06.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var startTextField: UITextField!
    
    @IBOutlet weak var goalTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func search(_ sender: Any) {
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! NextViewController
        nextVC.startText = startTextField.text!
        nextVC.goalText = goalTextField.text!
    }
    
}

