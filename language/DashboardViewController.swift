//
//  DashboardViewController.swift
//  language
//
//  Created by Arif Khan on 11/12/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DashboardViewController:  UIViewController {
    
    var myTextFields = [UITextField]()
    var myButtons = [UIButton]()
    var myLabels = [UILabel]()
    
    @IBOutlet weak var totalWordTextField: UITextField!
    @IBOutlet weak var knownWordsTextField: UITextField!
    @IBOutlet weak var percentTextField: UITextField!
    
    @IBOutlet weak var totalWordLabel: UILabel!
    @IBOutlet weak var myVoacabularyLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var competeButton: UIButton!
    
    @IBAction func addNewWord(_ sender: Any) {
        
        let oViewController = storyboard!.instantiateViewController(withIdentifier: "AddNewWordViewController") as! AddNewWordViewController
        
        navigationController!.pushViewController(oViewController, animated: true)
        
    }
    @IBOutlet weak var addNewWordButton: UIButton!
    @IBAction func startTest(_ sender: Any) {
        //in case of no deletion, select pin and navigate to show pictures
        let oViewController = storyboard!.instantiateViewController(withIdentifier: "WordTableViewController") as! WordTableViewController
        
        navigationController!.pushViewController(oViewController, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setColorsAndBorders()
        
        totalWordTextField.isUserInteractionEnabled = false
        totalWordTextField.text = getTotalWordCount().description
        
        knownWordsTextField.text = getMyWordCount(loginId: UserManager.GetLogedInUser()!, learningStatus: wordLearningStatus.mastered).description
        
        percentTextField.text = UtilityFunction.getPercentKnownWords(totalWords: totalWordTextField.text!, knownWords: knownWordsTextField.text!)
    }
    
    func getTotalWordCount() -> NSInteger {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let word = NSFetchRequest<Words>(entityName: "Word")
        if let result = try? context.fetch(word) {
            return result.count
        }
        return 0
    }
    
    func getMyWordCount(loginId: String, learningStatus: String? ) -> NSInteger {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let userWords = NSFetchRequest<UserWords>(entityName: "UserWords")
        
        let searchQuery = NSPredicate(format: "loginId = %@ AND learningStatus = %@", argumentArray: [loginId, learningStatus])
        userWords.predicate = searchQuery
        
        if let result = try? context.fetch(userWords) {
            return result.count
        }
        return 0
    }
    
    func setColorsAndBorders() {
        myTextFields = [totalWordTextField,knownWordsTextField,percentTextField]
        myButtons = [competeButton, addNewWordButton]
        myLabels = [totalWordLabel, myVoacabularyLabel, percentLabel]
        
        for item in myTextFields {
            item.setPreferences()
        }
        
        for item in myButtons {
            item.setPreferences()
        }
        
        for item in myLabels {
            item.setPreferences()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
