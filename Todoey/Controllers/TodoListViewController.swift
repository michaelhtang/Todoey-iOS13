//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
//
//        //Ternary operator
//        //Value = condition ? valueIfTrue : valueIfFalse
//
            cell.accessoryType = item.done ? .checkmark : .none
    } else {
            cell.textLabel?.text = "No Items Added"
        
    
        
    }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
//        done property toggle
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        deleting entries - notice the order
//        enable instead of done property toggle to delete entries
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        if let item = todoItems?[indexPath.row] {
        do {
        try realm.write {
            //handles done status
            item.done =  !item.done
            //deletes the selected entry
            //uncomment next line to enable delete functionality
//            realm.delete(item)
            }
        } catch {
            print("error while saving done status \(error)")
        }
            tableView.reloadData()
        
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
        }
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let selectedItem = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(selectedItem)
                }
            } catch {
                print("error while deleting item \(error)")
            }
        }
    }
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                print("Error saving new items \(error)")
            }
            self.tableView.reloadData()
        }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - Model Manipulation Methods

////external and internal parameter with default parameter
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        }


}
//MARK: - Search bar functionality

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

