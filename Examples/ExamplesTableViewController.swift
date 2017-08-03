//
//  ExamplesTableViewController.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 4/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit

class ExamplesTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleTableViewCell") as! ExampleTableViewCell
        
        cell.label.text = "CalendarDayView"
        
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

class ExampleTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}


