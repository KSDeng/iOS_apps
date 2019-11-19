//
//  TodoEditController.swift
//  Todos
//
//  Created by DKS_mac on 2019/11/18.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit

protocol TodoDelegate {
    func addTodo(taskName: String)
    func editTodo(taskName: String)
}

class TodoEditController: UITableViewController {

    var delegate: TodoDelegate?
    var taskName: String?
    
    @IBOutlet weak var todoInputTextField: UITextField!
    
    @IBAction func confirmAdd(_ sender: UIBarButtonItem) {
        if let taskName = self.todoInputTextField.text, !taskName.isEmpty {
            if self.taskName != nil{    // 编辑任务
                delegate?.editTodo(taskName: taskName)
            }else{                      // 添加任务
                delegate?.addTodo(taskName: taskName)
            }
        }
        // 将当前视图出栈(navigationController为内置变量)
        // 针对在navigationController中用show(push)方式出现的视图
        // 天气app中使用的dismiss用于showModal方式出现的视图
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 进入当前页面时将光标定位到文本输入框(成为第一个响应者)
        todoInputTextField.becomeFirstResponder()
        todoInputTextField.text = taskName
        // taskName = nil

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
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
