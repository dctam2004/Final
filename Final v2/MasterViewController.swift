//
//  MasterViewController.swift
//  Final v2
//
//  Created by Tam, Danny on 2017-11-21.
//  Copyright © 2017 Tam, Danny. All rights reserved.
//

import UIKit
import CoreData
import Zip

class MasterViewController: UITableViewController
{
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var objects = Array<JSON>()
    var likeSwitches = Array<Bool>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add "watch" file extension to Zip
        Zip.addCustomFileExtension("watch")
        
        // Load JSON
        if let file = Bundle(for: AppDelegate.self).path(forResource: "watchfaces", ofType: "json")
        {
            do
            {
                let data = try NSData(contentsOfFile: file) as Data
                let json = try JSON(data: data)
                self.objects = json["watchfaces"].arrayValue
            }
            catch
            {
                print("Can't open watch JSON file")
            }
        }
        
        for _ in 1...objects.count
        {
            likeSwitches.append(false)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func insertNewObject(_ sender: Any)
    {
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetail" || segue.identifier == "showDetailFromButton"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                let object = objects[indexPath.row]
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row]
        
        //Load watch face description 
        (cell.contentView.viewWithTag(10) as! UILabel).text = object["name"].stringValue
        
        if let button = (cell.contentView.viewWithTag(20) as? UIButton)
        {
            // Add an action for the event when the like button is pressed
            button.addTarget(self, action: #selector(imageClicked), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func imageClicked(sender: UIButton)
    {
        // Determine which row
        let point = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)

        let i = indexPath!.row
        let likeSwitch = likeSwitches[i]
        
        if likeSwitch
        {
            sender.setImage(UIImage(named: "like-button-png-2")?.withRenderingMode(.alwaysOriginal), for: [])
            likeSwitches[i] = false
        }
        else
        {
            sender.setImage(UIImage(named: "like-on")?.withRenderingMode(.alwaysOriginal), for: [])
            likeSwitches[i] = true
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert
        {
        }
    }
}
