//
//  WordTranslationViewController.swift
//  language
//
//  Created by Arif Khan on 11/10/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

//
//  WordListViewController.swift
//  language
//
//  Created by Arif Khan on 11/9/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit

class WordTranslationViewController:  UIViewController {
    
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    @IBOutlet weak var sourceSentence: UITextField!
    @IBOutlet weak var translatedSentence: UITextField!
    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setColorsAndBorders()
    
    }
    
    func setColorsAndBorders() {
        myTextFields = [sourceSentence,translatedSentence]
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



