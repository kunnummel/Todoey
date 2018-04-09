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
    let dataFilePath = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadItems()
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
        saveItems()
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
            self.saveItems()
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error\(error)")
        }
        
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
        let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Item].self, from: data)
        }
        catch{
            print("Decoding error - \(error)")
        
        }
    }
}
}

