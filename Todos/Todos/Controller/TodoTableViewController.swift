//
//  TodoTableViewController.swift
//  Todos
//
//  Created by DKS_mac on 2019/11/11.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {

    var editRow = 0
    
    // 每次改变todos数组就保存数据
    var todos: [Todo] = [] {
        didSet{
            saveData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // 导航栏添加编辑按钮
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        editButtonItem.title = "编辑"
    }
    
    // 批量删除
    @IBAction func batchDeleteAction(_ sender: UIBarButtonItem) {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                todos.remove(at: indexPath.row)
            }
            
            tableView.beginUpdates() // 把对视图的批量操作放在这两句话中间可以提高性能
            tableView.deleteRows(at: indexPaths, with: .left)
            tableView.endUpdates()  // 把对视图的批量操作放在这两句话中间可以提高性能
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editButtonItem.title = isEditing ? "完成" : "编辑"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

    
    // 渲染每一行时都会调用该方法，indexPath即为当前行的索引
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 获取TodoCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! TodoCell
        
        // Configure the cell...
            
        cell.taskNameLabel.text = todos[indexPath.row].name
        cell.checkLabel.text = todos[indexPath.row].checked ? "✅" : ""
            
        return cell
    }
    
    // 选中tableView中的某个cell时系统调用该函数
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing {
            todos[indexPath.row].checked = !todos[indexPath.row].checked
            
            // 更改打勾状态
            let getCell = tableView.cellForRow(at: indexPath) as! TodoCell
            getCell.checkLabel.text = todos[indexPath.row].checked ? "✅" : ""
            
            // 每次点击之后都取消选中
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
            todos.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    

    // Override to support rearranging the table view.
    // 编辑状态下才能移动
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        // 移动数据
        let todoMove = todos.remove(at: fromIndexPath.row)
        todos.insert(todoMove, at: to.row)
        
        // 更新视图
        // tableView.moveRow(at: fromIndexPath, to: to)
        // 重新加载数据(否则会有移动后的单元格无法交互的bug)
        tableView.reloadData()
        
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addTodoSegue" {
            let dest = segue.destination as! TodoEditController
            dest.delegate = self
            dest.title = "添加任务"
        }else if segue.identifier == "editTodoSegue" {
            // 获取将要转到的视图，此时已经确定其类型为TodoEditController，可进行强制type casting
            let dest = segue.destination as! TodoEditController
            dest.delegate = self
            let cell = sender as! TodoCell
            // 获取点击的cell的索引，取出Todo，正向传值
            editRow = tableView.indexPath(for: cell)!.row
            // print("edit row \(editRow)")
            dest.taskName = todos[editRow].name
            dest.title = "编辑任务"
            
        
        }
    }
    
}

extension TodoTableViewController: TodoDelegate {
    func addTodo(taskName: String) {
        todos.append(Todo(name: taskName, checked: false))
        let index = IndexPath(row: todos.count - 1, section: 0)
        tableView.insertRows(at: [index], with: .right)
        
    }
    func editTodo(taskName: String) {
        print("editTodo \(self.editRow)")
        todos[editRow].name = taskName
        
        let cell = tableView.cellForRow(at: IndexPath(row: editRow, section: 0)) as! TodoCell
        cell.taskNameLabel.text = taskName
        editRow = 0
        
    }
    
    // 利用用户默认数据库进行数据本地存储
    func saveData() {
        do{
            let data = try JSONEncoder().encode(todos)
            UserDefaults.standard.set(data, forKey: "todos")
        }catch{
            print(error)
        }
    }
    func loadData() {
        do {
            if let data = UserDefaults.standard.data(forKey: "todos"){
                todos = try JSONDecoder().decode([Todo].self, from: data)
            }
        }catch{
            print(error)
        }
    }
}
