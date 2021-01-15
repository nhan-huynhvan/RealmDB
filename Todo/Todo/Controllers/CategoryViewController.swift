//
//  CategoryViewController.swift.swift
//  Todo
//
//  Created by Nhan Huynh on 1/12/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readingCategies()
        // Hide back icon on category screen
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.flatBlue()

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Category()
            newItem.name = textField.text!
            newItem.color = UIColor.randomFlat().hexValue()
            self.saveCategory(category: newItem)
        }
        alert.addTextField { (field) in
            field.placeholder = "Create new category"
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        User.logout()
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name
        cell.backgroundColor = UIColor(hexString: category!.color)
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category!.color)!, returnFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Going detail
        performSegue(withIdentifier: Constants.todoScreen, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func saveCategory(category: Category) {
        try! realm.write {
            realm.add(category)
        }
        tableView.reloadData()
    }
    
    func readingCategies() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            try! self.realm.write {
                self.realm.delete(category)
            }
        }
    }
    
}
