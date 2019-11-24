//
//  TaskListController.swift
//  Todo-coredata
//
//  Created by DKS_mac on 2019/11/20.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit
import CoreData

class TaskListController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var todos:[Todo] = []
    
    @IBOutlet weak var taskSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        editButtonItem.title = "编辑"
        
        // 指定代理，为实现UISearchBarDelegate中的功能做准备
        taskSearchBar.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveData()
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

    // 用动态数据渲染每个cell的内容时，TableView的类型必须是Dynamic
    // 若cell内容固定，如需要将outlet链接到Controller中，则TableView的类型必须是Static
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)) as! TodoTaskCell

        // Configure the cell...
        cell.taskNameLabel.text = todos[indexPath.row].name
        cell.checkLabel.text = todos[indexPath.row].checked ? "✅" : ""
        
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
            let deleteTodo = todos.remove(at: indexPath.row)
            context.delete(deleteTodo)
            
            showTodos()
            updateIndexAfterDelete(deleteIndex: Int(deleteTodo.index))
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    // 删除后index更新
    private func updateIndexAfterDelete(deleteIndex: Int) {
        if todos.count > deleteIndex {
            for i in deleteIndex ... todos.count - 1 {
                todos[i].index = todos[i].index - 1
            }
        }
    }
    

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        // 添加index字段实现重排序与存储
        showTodos()
        
        let fromRow = Int(todos[fromIndexPath.row].index)
        let toRow = Int(todos[to.row].index)
        
        if fromRow < toRow {
            todos[fromRow].index = Int32(toRow)
            for i in fromRow + 1 ... toRow {
                todos[Int(i)].index = todos[Int(i)].index - 1
            }
        }else {
            todos[fromRow].index = Int32(toRow)
            for i in toRow ... fromRow - 1 {
                todos[Int(i)].index = todos[Int(i)].index + 1
            }
        }
        // showTodos()
        todos = todos.sorted(by: {$0.index < $1.index})
        showTodos()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing {
            let cell = tableView.cellForRow(at: indexPath) as! TodoTaskCell
            todos[indexPath.row].checked = !todos[indexPath.row].checked
            cell.checkLabel.text = todos[indexPath.row].checked ? "✅" : ""
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // 先保留原有功能
        super.setEditing(editing, animated: animated)
        // editButtonItem也是TableView的内置变量
        editButtonItem.title = isEditing ? "完成" : "编辑"
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
        if segue.identifier == "addTodo" {
            let dest = segue.destination as! TaskEditController
            dest.delegate = self
        } else if segue.identifier == "editTodo" {
            let dest = segue.destination as! TaskEditController
            dest.delegate = self
            
            dest.title = "编辑任务"
            
            // 设置编辑的位置
            let cell = sender as! TodoTaskCell
            dest.taskName = cell.taskNameLabel.text
            dest.editRow = tableView.indexPath(for: cell)?.row      // 根据cell获得row索引
            
        }
        
    }
    
    
    @IBAction func batchDelete(_ sender: UIBarButtonItem) {
        
        // 获取当前选中的所有行
        if var selectedIndexPaths = tableView.indexPathsForSelectedRows {
            // 按row从大到小排序, 避免依次删除时发生index out of range错
            selectedIndexPaths.sort(by: {$0.row > $1.row})
            
            for indexPath in selectedIndexPaths {
                let deleteTodo = todos.remove(at: indexPath.row)
                context.delete(deleteTodo)
                updateIndexAfterDelete(deleteIndex: Int(deleteTodo.index))
            }
            
            tableView.deleteRows(at: selectedIndexPaths, with: .left)
            
        }
    }
    
    private func saveData(){
        // 将数据保存在CoreData中
        do {
            try context.save()
        } catch{
            print(error)
        }
    }
    
    private func loadData(){
        // 从CoreData中加载数据
        // 注意加载数据是有返回值的
        do {
            try todos = context.fetch(Todo.fetchRequest())
            todos = todos.sorted(by: {$0.index < $1.index})
        } catch {
            print(error)
        }
    }
    
    private func showTodos(){
        print("")
        for todo in todos {
            print("\(todo.index), \(todo.name), \(todo.checked)")
        }
    }
    
    
}

// 实现反向传值的相关功能
extension TaskListController: TodoDelegate {
    
    func addTodo(taskName: String) {
        // 实例化CoreData对象
        let newTodo = Todo(context: context)
        newTodo.index = Int32(todos.count)
        newTodo.name = taskName
        newTodo.checked = false
        
        todos.append(newTodo)
        
        let index = IndexPath(row: todos.count - 1, section: 0)
        tableView.insertRows(at: [index], with: .right)
        
    }
    
    func editTodo(taskName: String, editRowIndex: Int) {
        todos[editRowIndex].name = taskName
        
        let cell = tableView.cellForRow(at: IndexPath(row: editRowIndex, section: 0)) as! TodoTaskCell
        cell.taskNameLabel.text = taskName
    }
    
}

// 实现搜索框相关功能
extension TaskListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.text!.isEmpty {
            doSearch()
        }else {
            loadData()
            // 放弃第一响应者，收回键盘
            // tableView.resignFirstResponder()     // 错误写法
            
            // 第一时间响应
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            doSearch()
        }
        tableView.reloadData()
    }
    
    private func doSearch(){
        do {
            try todos = context.fetch(Todo.fetchRequest()).filter({$0.name?.contains(taskSearchBar.text!) ?? false}).sorted(by: {$0.index < $1.index})
        } catch {
            print(error)
        }
    }
}
