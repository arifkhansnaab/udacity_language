//
//  WordTranslationViewController.swift
//  language
//
//  Created by Arif Khan on 11/10/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit

class WordTranslationViewController:  UIViewController {
    
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    var sourceSentense : String = ""
    var translatedSentence : String = ""
    
    @IBOutlet weak var translatedLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var sourceSentenceTextField: UITextField!
    @IBAction func checkConversion(_ sender: Any) {
        
        if ( translatedSentenceTextField.text == translatedSentence ) {
            rightLabel.isHidden = false
            wrongLabel.isHidden = true
            translatedLabel.isHidden = true
        } else {
            rightLabel.isHidden = true
            wrongLabel.isHidden = false
            translatedLabel.isHidden = false
            translatedLabel.text = translatedSentence
        }
    }
    @IBOutlet weak var translatedSentenceTextField: UITextField!
    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setColorsAndBorders()
        
        translatedSentenceTextField.autocorrectionType = UITextAutocorrectionType.no
        sourceSentenceTextField.text = sourceSentense
        
        wrongLabel.isHidden = true
        rightLabel.isHidden = true
        //translatedLabel.isHidden = true
    
    }
    
    func setColorsAndBorders() {
        myTextFields = [sourceSentenceTextField,translatedSentenceTextField]
        myButtons = [testButton]
        
        for item in myTextFields {
            item.setPreferences()
        }
        
        for item in myButtons {
            item.setPreferences()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



