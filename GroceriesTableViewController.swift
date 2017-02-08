//
//  GroceriesTableViewController.swift
//  Grocery List
//
//  Created by Warren Hansen on 2/8/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import CoreData

class GroceriesTableViewController: UITableViewController {
    var groceries = [NSManagedObject]()
    var managedObjectContext: NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelagate.persistentContainer.viewContext
        loadData()
    }
    func loadData() {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Grocery")
        do {
            let results = try managedObjectContext?.fetch(request)
            groceries = results!
            tableView.reloadData()
        }
        catch {
        fatalError("Error in retrieving Grocery item")
        }
    }
    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Grocery Item", message: "What would you like?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textfield: UITextField) in
            
        }
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { [weak self] (action: UIAlertAction) in
            let textField = alertController.textFields?.first
            //self?.groceries.append(textField!.text!)
            
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: (self?.managedObjectContext)!)
            let grocery = NSManagedObject(entity: entity!, insertInto: (self?.managedObjectContext)!)
            grocery.setValue(textField?.text, forKey: "item")
            do {
                try self?.managedObjectContext?.save()
            } catch {
                fatalError("Error in storint data")
            }
            self?.loadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath)
        let grocery = self.groceries[indexPath.row]
        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        return cell
    }
}
