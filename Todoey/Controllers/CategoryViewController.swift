//
//  CategoryViewController.swift
//  Todoey
//
//  Created by mohammed abdulla kadib on 2/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoires: Results<Category>?
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        
        navBar.backgroundColor = UIColor(hexString: "#1D9BF6")
    }

    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            
            textField.placeholder = "Add a New Category"
        
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoires?.count ?? 1
        
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoires?[indexPath.row].name ?? "No Categories added yet"
        
        if let category = categoires?[indexPath.row] {
            guard let categoryColour = UIColor(hexString: category.color) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: categoryColour, isFlat: true)
        }
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let desticnationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            desticnationVC.selectedCategory = categoires?[indexPath.row]
            
        }
        
        
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write(){
                realm.add(category)
            }
            
        } catch {
            print("Error saving categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categoires = realm.objects(Category.self)
        
        tableView.reloadData()

    }
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        
        if let categoryForDeletion = self.categoires?[indexPath.row] {
            
            do {
                
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
                
            } catch {
                print("Error deleting category \(error)")
            }
            
            tableView.reloadData()
            
        }
        
    }
    
    
}

