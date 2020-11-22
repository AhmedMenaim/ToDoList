//
//  TaskCell.swift
//  ToDoList
//
//  Created by Crypto on 11/19/20.
//

import UIKit

class TaskCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var buttonCheckMarkOutlet: UIButton!
    @IBOutlet weak var lblTaskTitleOutlet: UILabel!
    
    //MARK: - Vars
    var checked: Bool = false
    //MARK: - Action
    @IBAction func buttonCheckMarkAction(_ sender: UIButton) {
        
        
        let checkedImage = UIImage(named: "checked")
        let uncheckedImage = UIImage(named: "unchecked")
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: lblTaskTitleOutlet.text!)
        if checked == false {
            sender.setImage(uncheckedImage, for: .normal)
            checked = true
            lblTaskTitleOutlet.attributedText = attributeString
        }
        else {
            sender.setImage(checkedImage, for: .normal)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            lblTaskTitleOutlet.attributedText = attributeString
            checked = false
            
        }
    }
    
}
