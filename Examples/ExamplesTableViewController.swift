//
//  ExamplesTableViewController.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 4/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit

class ExamplesTableViewController: UITableViewController {
    
    let examplesNames = ["ColorCalendarDayViewExample","ColorCalendarViewExample"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examplesNames.count
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleTableViewCell") as! ExampleTableViewCell
        
        
        
        cell.label.text = examplesNames[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "\(examplesNames[indexPath.row])Segue", sender: self)
    }
    
//    ColorCalendarDayViewExampleSeguea
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

class ExampleTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}


