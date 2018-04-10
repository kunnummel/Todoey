//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac Dev on 10/04/2018.
//  Copyright © 2018 Mac Dev. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var catArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequest()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cat = catArray[indexPath.row]
        cell.textLabel?.text = cat.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
    
   func fetchRequest (with request : NSFetchRequest<Category> = Category.fetchRequest()){
    do{
       
        catArray = try context.fetch(request)
        
    } catch{
        print("Error fetching category \(error)")
    }
    
    }
    func saveContext(){
        do{
            try context.save()
        }catch{
            print ("Error saving category Context \(error)")
        }
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Categories", message: "Enter the category", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Add Category", style: UIAlertActionStyle.default) { (action) in
            let cat = Category(context: self.context)
            cat.name = textField.text!
            self.catArray.append(cat)
            self.saveContext()
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
