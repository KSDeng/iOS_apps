//
//  MealTableViewController.swift
//  MyFoodTracker
//
//  Created by DKS_mac on 2019/10/20.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {

    var meals = [Meal]()
    
    
    // 视图加载之后的操作
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provied by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load data.
        if let savedMeals = loadMeals() {
            // load the saved data.
            meals += savedMeals
        }else {
            
            // load the sample data.
            loadSampleMeals()
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        // Request a cell from the table view
        // Downcast the UITableViewCell object to MealTableViewCell
        // Unwrap the returned optional value.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else{
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetch the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        // Use the meal object to configure the cell.
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // 以下两行调换位置会出错，为什么？
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Save the meals.
            saveMeals()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // segue进行前将被调用的方法
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // override得来的函数先调用父类的同型函数，编程的好习惯
        super.prepare(for: segue, sender: sender)
        
        // 这里的identifier可在storyboard的attributes inspector中设置
        switch (segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
        case "ShowDetail":
            // 从sender中依次获取segue的目的地、选中的cell
            guard let mealDetailViewController = segue.destination as?
                MealViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "nothing")")
            }
            // 从tableView中获取选中的cell的索引
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table.")
            }
            
            // 根据索引获取Meal实例，并设置到mealDetailViewController的对象成员中
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "nothing")")
        }

    }
    
    
    private func loadSampleMeals() {
        // load the images in the assets
        let photo1 = UIImage(named: "Meal1")
        let photo2 = UIImage(named: "Meal2")
        let photo3 = UIImage(named: "Meal3")
        
        // instantiate Meal instances
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1.")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2.")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3.")
        }
        
        // add the Meal instances to the meals array
        meals += [meal1, meal2, meal3]
        
        
    }
    
    // unwind函数应该在回退的目的地视图中实现
    // 自定义动作函数, 处理unwind segue
    // 必须是这种形式
    // 编译器怎么知道要调用这个函数？答：在storyboard设置exit segue时，XCode自动在该函数名后面加上"WithSender"
    // 这个函数在什么时候被执行？
    @IBAction func unwindToMealListView(sender: UIStoryboardSegue) {
        
        // 判断发起者是否为MealViewController并获取其传过来的meal
        if let sourceViewController = sender.source as? MealViewController,
            let meal = sourceViewController.meal {
            
            // 有被选中的Meal
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                // Update a existing meal.
                print("Update a existing meal.")
                
                // 根据编辑的结果更新meals数组
                meals[selectedIndexPath.row] = meal
                // 重新加载数据，更新列表
                // 第二个参数设置更新的动画
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meal.
                print("Add a new meal.")
                
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the meals.
            saveMeals()

        }
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        
    }
    
    
    private func loadMeals() -> [Meal]? {
        print("Loading data from \(Meal.ArchiveURL.path).")
        // return NSKeyedUnarchiver.unarchivedObject(ofClass: Meal, from: Meal.ArchiveURL.path) as? [Meal]
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }

}
