//
//  AddNewWordViewController.swift
//  language
//
//  Created by Arif Khan on 11/13/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import UIKit

class AddNewWordViewController: UIViewController {

    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    
    @IBOutlet weak var originalWordTextBox: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addNewWordButton: UIButton!
    @IBOutlet weak var addAddedNoteTextBox: UITextField!
    @IBOutlet weak var translatedRomanTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setColorsAndBorders()
        
        translatedRomanTextBox.autocorrectionType = UITextAutocorrectionType.no
    }
    
    func addWordToCloud() {
        
        let jsonWord = JsonWord(sourceWord: (originalWordTextBox.text)!, translatedWord: (translatedRomanTextBox.text)!, language: "Urdu", publishedDate: UtilityFunction.getConvertedDateString()!, publishedBy: UserManager.GetLogedInUser()!)
        
        LanguageApi.sharedInstance.postWord(jsonWord as JsonWord) { (result, error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async( execute: {
                   print ("added")
                })
            }
        }

    }

    @IBAction func addNewWord(_ sender: Any) {
        
        if ( originalWordTextBox.text?.characters.count == 0 ) {
            errorLabel.text = "Source word cannot be empty"
            return
        }
        
        if ( translatedRomanTextBox.text?.characters.count == 0 ) {
            errorLabel.text = "Translated word cannot be empty"
            return
        }
        
        addWordToCloud()
        return
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!

        _ = Word(source: originalWordTextBox.text!, romanWord: translatedRomanTextBox.text!, context: context)
        
        do {
            try context.save()
            
            let alert = UIAlertController(title: "Alert", message: "User registered successfully", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                let oViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController!.pushViewController(oViewController, animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } catch let error as NSError {
            print (error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setColorsAndBorders() {
        myTextFields = [originalWordTextBox,translatedRomanTextBox,addAddedNoteTextBox]
        myButtons = [addNewWordButton]
        
        for item in myTextFields {
            item.setPreferences()
        }
        
        for item in myButtons {
            item.setPreferences()
        }
    }

}
