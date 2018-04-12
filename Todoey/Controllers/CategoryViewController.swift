//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac Dev on 10/04/2018.
//  Copyright © 2018 Mac Dev. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var catArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCatgories()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        cell.textLabel?.text = catArray?[indexPath.row].name ?? "No Categories added"
        cell.backgroundColor = UIColor.init(hexString: catArray?[indexPath.row].color ?? "000000")
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray?[indexPath.row]
        }
    }
    
   func loadCatgories() {
     catArray = realm.objects(Category.self)
    tableView.reloadData()
     }
 
    func saveCategories(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print ("Error saving category Context \(error)")
        }
    }
    override func updateModel(at indexPath:IndexPath){
        
        if (self.catArray?[indexPath.row]) != nil{
         do{
         try self.realm.write {
         self.realm.delete(self.catArray![indexPath.row])
         }
         }catch{
         print("error deleting \(error)")
         }
         
        }
        
        
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Categories", message: "Enter the category", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Add Category", style: UIAlertActionStyle.default) { (action) in
            let cat = Category()
            cat.name = textField.text!
            cat.color = UIColor.randomFlat.hexValue()
            self.saveCategories(category: cat)
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Please enter the category"
            textField = alertTextField
        }
        alert.addAction(action)
       present(alert, animated: true, completion: nil)
        
    }
}

