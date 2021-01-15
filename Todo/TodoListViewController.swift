//
//  TodoListViewController.swift
//  Todo
//
//  Created by Nhan Huynh on 1/12/21.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            readingItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let color = selectedCategory?.color {
            title = selectedCategory?.name
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controll does not exist.")
            }
            navBar.barTintColor = UIColor(hexString: color)
            navBar.tintColor = ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            DispatchQueue.main.async {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.done = false
                newItem.color = UIColor.randomFlat().hexValue()
                newItem.dateCreated = Date()
                self.saveItems(item: newItem)
            }
            
        }
        alert.addTextField { (field) in
            field.placeholder = "Create new item"
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = items?[indexPath.row]
        cell.textLabel?.text = item?.title
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: item!.color)!, returnFlat: true)
        cell.accessoryType = item?.done == true ? .checkmark : .none
        cell.backgroundColor = UIColor(hexString: item!.color)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            try! realm.write {
                item.done = !item.done
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    func saveItems(item: Item) {
        if let currentCategory = self.selectedCategory {
            
            try! realm.write {
                currentCategory.items.append(item)
            }
        }
        
        tableView.reloadData()
    }
    
    func readingItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            try! self.realm.write {
                self.realm.delete(item)
            }
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    // Revert default list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            readingItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
