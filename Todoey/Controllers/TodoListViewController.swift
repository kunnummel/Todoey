//
//  ViewController.swift
//  Todoey
//
//  Created by Mac Dev on 05/04/2018.
//  Copyright © 2018 Mac Dev. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = (item.done ? .checkmark : .none)
            cell.backgroundColor = UIColor.init(hexString: selectedCategory!.color)!.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count))
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: false)
        }
        else {
            print ("yes")
            cell.textLabel?.text = "No value found for this category"
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
               item.done = !item.done
                tableView.reloadData()
            }
            }catch{
                print ("error updating")
            }
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new alert", message: "", preferredStyle: .alert
    )
        let action = UIAlertAction(title: "Add Item", style: UIAlertActionStyle.default) {(action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            currentCategory.items.append(newItem)
            }
                }catch{
                    print("Error saving realm \(error)")
                }
            self.tableView.reloadData()
        }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
 
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        // tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        
        if (todoItems?[indexPath.row]) != nil{
            do{
                try realm.write {
                    realm.delete(self.todoItems![indexPath.row])
                }
            }catch{
                print("error deleting \(error)")
            }
            
        }
    }

}

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text!.count<1){
           loadItems()
        }
        else{
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
             tableView.reloadData()
        }
       
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count < 1){
            loadItems()
              tableView.reloadData()
        }
    }
}
