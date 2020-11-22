//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Crypto on 11/19/20.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
//MARK: - Outlets
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var textFieldTaskTitle: UITextField!
    
    
    //MARK: - Observe
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//MARK: - Actions
    @IBAction func saveButtonAction(_ sender: Any) {
        guard let priority = Priority(rawValue: segmentedControlOutlet.selectedSegmentIndex),let title = textFieldTaskTitle.text else {return}
        let myTask = Task(taskTitle: title, taskPriority: priority)
        taskSubject.onNext(myTask)
        self.dismiss(animated: true, completion: nil)
    }
}
