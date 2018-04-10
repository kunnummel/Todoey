//
//  ViewController.swift
//  Todoey
//
//  Created by Mac Dev on 05/04/2018.
//  Copyright © 2018 Mac Dev. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

       
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
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
        do{
           try context.save()
        }catch{
           print("Error saving core data \(error)")
        }
        
    }
    
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        executeRequest(with: request)
    }
    func executeRequest(with request:NSFetchRequest<Item>,predicate : NSPredicate? = nil){
        let catPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        if(predicate == nil){
            request.predicate = catPredicate
        }else {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate,predicate!])
    }
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching from context - \(error)")
            
        }
    }
 
}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if((searchBar.text?.count)! < 1){
            return
        }
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       
        let sortDesc = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDesc]
        executeRequest(with: request,predicate: predicate)
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
        loadItems()
             self.tableView.reloadData()
        }
       
    }
}

