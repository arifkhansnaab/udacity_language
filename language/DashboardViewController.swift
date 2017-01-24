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
    var Words = [JsonWord]()
    
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
        downloadGoogleWordAndPopulateCollection()
        totalWordTextField.isUserInteractionEnabled = false
    }
    
    func getTotalWordCount() -> NSInteger {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let word = NSFetchRequest<Word>(entityName: "Word")
        if let result = try? context.fetch(word) {
            return result.count
        }
        return 0
    }
    
    func getTotalWordCountFromCloud() -> NSInteger {
        return self.Words.count
    }
    
    func checkWordExist(lword: String) -> Word? {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let userWords = NSFetchRequest<Word>(entityName: "Word")
        
        let searchQuery = NSPredicate(format: "sourceWord = %@", argumentArray: [lword])
        userWords.predicate = searchQuery
        
        
        if let result = try? context.fetch(userWords) {
            for object in result {
                return (object as Word)
            }
        }
        return nil
    }

    
    func downloadGoogleWordAndPopulateCollection() {
        let date = NSDate()
        
        LanguageApi.sharedInstance.getWords(date as Date) { (result, error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async( execute: {
                    self.Words = result!
                    self.syncLocalFromCloud()
                    self.addWordFromClouldToLocal()
                    self.totalWordTextField.text = self.getTotalWordCount().description
                    self.knownWordsTextField.text = self.getMyWordCount(loginId: UserManager.GetLogedInUser()!, learningStatus: wordLearningStatus.mastered).description
                    
                    self.percentTextField.text = UtilityFunction.getPercentKnownWords(totalWords: self.totalWordTextField.text!, knownWords: self.knownWordsTextField.text!)
                })
            }
        }
    }
    
    func addWordFromClouldToLocal() {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        
        for oWord in self.Words {
        
            if ( checkWordExist(lword: oWord.sourceWord!) == nil ) {
            
            _ = Word(source: oWord.sourceWord!, romanWord: oWord.translatedWord!, context: context)
            
            do {
                try context.save()
            }
         catch let error as NSError {
            print (error)
          }
        }
        }
    }
    
    
    func IsWordInCloud(word: String) -> Bool {
         for oWord in self.Words {
            if ( oWord.sourceWord == word ) {
                return true;
            }
        }
        return false
    }
    
    func syncLocalFromCloud() {
        syncLocalFromCloudWords()
        syncLocalFromCloudUserWords()
    }
    
    func syncLocalFromCloudUserWords() {
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let userWords = NSFetchRequest<UserWords>(entityName: "UserWords")
        
        let searchQuery = NSPredicate(format: "loginId = %@", argumentArray: [UserManager.GetLogedInUser()!])
        userWords.predicate = searchQuery
        
        if let result = try? context.fetch(userWords) {
            for object in result {
                if ( IsWordInCloud(word: (object as UserWords).word!) == false ) {
                    context.delete(object)
                }
            }
        }
        do {
            try context.save()
        }
        catch let error as NSError {
            print (error)
        }
    }
    
    func syncLocalFromCloudWords() {
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let word = NSFetchRequest<Word>(entityName: "Word")
        if let result = try? context.fetch(word) {
            for object in result {
                if ( IsWordInCloud(word: (object as Word).sourceWord!) == false ) {
                    context.delete(object)
                }
            }
        }
        
        do {
            try context.save()
        }
        catch let error as NSError {
            print (error)
        }
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
