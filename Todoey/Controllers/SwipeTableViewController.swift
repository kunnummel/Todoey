//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Mac Dev on 10/04/2018.
//  Copyright © 2018 Mac Dev. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {return nil}
        let deleteAction = SwipeAction(style: SwipeActionStyle.destructive, title: "Delete?"){action,indexPath in
            
            self.updateModel(at: indexPath)
            print("delete action")
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        
        options.expansionStyle = .destructive
        return options
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.tintColor = UIColor.white
        cell.textLabel?.sizeToFit()
        cell.delegate = self

       return cell
    }
    
    func updateModel(at indexPath:IndexPath){
        
    }
    

}
