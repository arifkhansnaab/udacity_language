//
//  WordListViewController.swift
//  language
//
//  Created by Arif Khan on 11/9/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit

class WordTableViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let data:[[String]] = [["What's going on","Always Respect your elders", "Glasses"],
                           ["Book","Camel", "Cat"]]
    
    let subs:[[String]] = [["3. 10/31/2016","3. 10/31/2016", "3. 10/31/2016"],
                           ["1. 10/03/2016","1. 10/03/2016", "1. 10/03/2016"]]
    
    let headers:[String] = ["New", "Known"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = subs[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(data[indexPath.section][indexPath.row])")
        
        //in case of no deletion, select pin and navigate to show pictures
        let oViewController = storyboard!.instantiateViewController(withIdentifier: "WordTranslationViewController") as! WordTranslationViewController
       
        navigationController!.pushViewController(oViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
