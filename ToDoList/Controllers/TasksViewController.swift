//
//  ViewController.swift
//  ToDoList
//
//  Created by Crypto on 11/19/20.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

public let ReuseIdentifier = "TaskCell"

class TasksViewController: UIViewController {

    //MARK: - Vars
    let disposeBag = DisposeBag()
    private var myTasks = BehaviorRelay<[Task]>(value: [])
    // private var myTasks = Variable<[Task]>([]) The best thing about variable that we can subscribe for it but unfortunately it's deprecated so we are gonna use BehaviorRelay which needs RxCocoa to be enabled
    private var filteredTasks = [Task] ()

    
    //MARK: - Outlets
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    @IBOutlet weak var tasksTableViewOutlet: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableViewOutlet.tableFooterView = UIView()
        tasksTableViewOutlet.register(UINib(nibName: ReuseIdentifier, bundle: nil), forCellReuseIdentifier: ReuseIdentifier)
    }
    
    // MARK: - Passing Task
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let myNavigationContoller = segue.destination as? UINavigationController, let addTaskVC = myNavigationContoller.viewControllers.first as? AddTaskViewController else {fatalError("NOT FOUND!!")}

        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { task in
                let priority = Priority(rawValue: self.segmentedControlOutlet.selectedSegmentIndex - 1)
//                self.myTasks.value.append(task) after changing it to behavior we need to do sth else which is
                var existingTasks = self.myTasks.value
                existingTasks.append(task) // in behaviorRelay we can't update or append so we have to change it
                self.myTasks.accept(existingTasks)
                self.filterTasks(priority: priority)

            }).disposed(by: disposeBag)
    }
    
    //MARK: - Updating TableView
    func updateTableView() {
        DispatchQueue.main.async {
            self.tasksTableViewOutlet.reloadData()
        }
    }
    
    //MARK: - Actions
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        let priority = Priority(rawValue: segmentedControlOutlet.selectedSegmentIndex - 1)
        filterTasks(priority: priority)
    }
    
    //MARK: - Filter Task
    func filterTasks(priority: Priority?) {
        
        if priority == nil {
            self.filteredTasks = self.myTasks.value
            updateTableView()
        }
        else {
            self.myTasks.map { tasks in
                return tasks.filter {$0.taskPriority == priority!}
            }.subscribe(onNext: { tasks in
                self.filteredTasks = tasks
                self.updateTableView()
                
            }).disposed(by: disposeBag)
        }
    }


}
//MARK: - Tableview methods
extension TasksViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tasksTableViewOutlet.dequeueReusableCell(withIdentifier: ReuseIdentifier) as! TaskCell
        cell.lblTaskTitleOutlet.text = self.filteredTasks[indexPath.row].taskTitle
        return cell
    }
    

}


