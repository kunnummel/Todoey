//
//  ViewController.swift
//  Todoey
//
//  Created by Mac Dev on 05/04/2018.
//  Copyright © 2018 Mac Dev. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "No Mike"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Yahoo Mike"
        itemArray.append (newItem3)
       
  //      if let items = defaults.array(forKey: "MyTodoListArray") as? [String]{
    //        itemArray=items
      //  }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = (item.done ? .checkmark : .none)

        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(itemArray[indexPath.row].done == true){
            itemArray[indexPath.row].done = false}
        else{
            itemArray[indexPath.row].done = true
        }
        tableView.reloadData()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new alert", message: "", preferredStyle: .alert
    )
        let action = UIAlertAction(title: "Add Item", style: UIAlertActionStyle.default) {(action) in
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "MyTodoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
}

