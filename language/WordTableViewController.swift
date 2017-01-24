//
//  WordListViewController.swift
//  language
//
//  Created by Arif Khan on 11/9/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WordTableViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Two types of words categories
    let headers:[String] = ["New", "Shaky"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        downloadFlickrPhotosAndPopulateCollection()

    }
    
    func downloadFlickrPhotosAndPopulateCollection() {
        
        let date = NSDate()
        
        LanguageApi.sharedInstance.getWords(date as Date) { (result, error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async( execute: {
                    _ = result!
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ( section == 0 ) {
            return getMyWordCount(loginId: UserManager.GetLogedInUser()!, learningStatus: wordLearningStatus.unknown)
        }
        
        return getMyWordCount(loginId: UserManager.GetLogedInUser()!, learningStatus: wordLearningStatus.shaky)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = data[indexPath.section][indexPath.row]
        
        if ( indexPath.section == 0 ) {
            cell.textLabel?.text = getMyWord(loginId: UserManager.GetLogedInUser()!, learningStatus: wordLearningStatus.unknown, position: indexPath.row)
        
            cell.detailTextLabel?.text = getMyWordNote(loginId: UserManager.GetLogedInUser()!, learningStatus: wordLearningStatus.unknown, position: indexPath.row)
        } else {
            cell.textLabel?.text = getMyWord(loginId: UserManager.GetLogedInUser()!, learningStatus: wordLearningStatus.shaky, position: indexPath.row)
            
            cell.detailTextLabel?.text = getMyWordNote(loginId: UserManager.GetLogedInUser()!, learningStatus: wordLearningStatus.shaky, position: indexPath.row)
        }
        
        cell.textLabel?.font = UIFont(name: colorFontConstant.fontName, size: colorFontConstant.fontSize)!
        return cell
    }
    
     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a
        
        header.contentView.backgroundColor = UIColor(red: colorFontConstant.redValue, green: colorFontConstant.greenValue, blue: colorFontConstant.blueValue, alpha: colorFontConstant.alphaValue)

        header.textLabel?.textColor = UIColor.white //make the text white
        header.textLabel?.font = UIFont(name: colorFontConstant.fontName, size: colorFontConstant.fontSize)!
    }
    
    func getMyWordCount(loginId: String, learningStatus: String? ) -> NSInteger {
        
        if ( learningStatus == wordLearningStatus.unknown ) {
            let context = CoreDataStackManager.sharedInstance().managedObjectContext!
            let words = NSFetchRequest<Word>(entityName: "Word")
            
            if let result = try? context.fetch(words) {
                for object in result {
                    
                    var word = checkWordInMyWordQueue(loginId: UserManager.GetLogedInUser()!, word: (object as Word).sourceWord!)
                    if ( word == nil ) {
                        
                        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
                        _ = UserWords(loginId: UserManager.GetLogedInUser()!, sourceWord: (object as Word).sourceWord!, status: wordLearningStatus.unknown, context: context)
                        
                        do {
                            try context.save()
                            
                        } catch let error as NSError {
                            print (error)
                        }
                    }
                }
            }

        }
        
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let userWords = NSFetchRequest<UserWords>(entityName: "UserWords")
        
        let searchQuery = NSPredicate(format: "loginId = %@ AND learningStatus = %@", argumentArray: [loginId, learningStatus])
        userWords.predicate = searchQuery
        
        
        if let result = try? context.fetch(userWords) {
            return result.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func checkWordInMyWordQueue(loginId: String, word: String) -> String? {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let userWords = NSFetchRequest<UserWords>(entityName: "UserWords")
        
        
        let searchQuery = NSPredicate(format: "loginId = %@ AND word = %@", argumentArray: [loginId, word])
        userWords.predicate = searchQuery
        
        
        if let result = try? context.fetch(userWords) {
            for object in result {
                return (object as UserWords).word
            }
        }
        return nil
    }
    
    func getMyWord(loginId: String, learningStatus: String?, position: NSInteger ) -> String? {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let userWords = NSFetchRequest<UserWords>(entityName: "UserWords")
        
        var count = 0
        
        let searchQuery = NSPredicate(format: "loginId = %@ AND learningStatus = %@", argumentArray: [loginId, learningStatus])
        userWords.predicate = searchQuery
        
        
        if let result = try? context.fetch(userWords) {
            for object in result {
                if ( count == position ) {
                    return (object as UserWords).word
                }
                count += 1
            }
        }
        return nil
    }
    
    func getMyWordNote(loginId: String, learningStatus: String?, position: NSInteger ) -> String? {
        let context = CoreDataStackManager.sharedInstance().managedObjectContext!
        let userWords = NSFetchRequest<UserWords>(entityName: "UserWords")
        
        let count = 0
        
        let searchQuery = NSPredicate(format: "loginId = %@ AND learningStatus = %@", argumentArray: [loginId, learningStatus])
        userWords.predicate = searchQuery
        
        
        if let result = try? context.fetch(userWords) {
            for object in result {
                if ( count == position ) {
                    return (object as UserWords).lastTouched?.description
                }
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        //NSLog("did select and the text is \(cell?.textLabel?.text)")
        
       // let value = data[indexPath.section][indexPath.row]
       // print("\(value)")
       // let translatedData = self.translatedData[indexPath.section][indexPath.row]
        
        //in case of no deletion, select pin and navigate to show pictures
        let oViewController = storyboard!.instantiateViewController(withIdentifier: "WordTranslationViewController") as! WordTranslationViewController
        
        oViewController.sourceSentense = (cell?.textLabel?.text)!
        //oViewController.translatedSentence = translatedData
       
        navigationController!.pushViewController(oViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
