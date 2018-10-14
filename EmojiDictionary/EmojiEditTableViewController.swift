//
//  EmojiEditTableViewController.swift
//  EmojiDictionary
//
//  Created by Татьяна on 09.10.2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

class EmojiEditTableViewController: UITableViewController {
    var emoji: Emoji?
    
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let captions = ["Symbol",
                    "Name",
                    "Description",
                    "Usage",
                    "Group"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let emoji = emoji {
            title = "Редактирование"
            update(with: emoji)
        } else {
            title = "Добавление"
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        tableView.sectionFooterHeight = 0.0;
        
        symbolTextField.delegate = self
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        usageTextField.delegate = self
        groupTextField.delegate = self
        
        updateSaveButton()
        
    }
    
    @IBAction func endEdit(_ sender: UITextField) {
        switch sender {
        case symbolTextField:
            nameTextField.becomeFirstResponder()
        case nameTextField:
            descriptionTextField.becomeFirstResponder()
        case descriptionTextField:
            usageTextField.becomeFirstResponder()
        case usageTextField:
            groupTextField.becomeFirstResponder()
        default:
            hideKeyboard()
        }
        updateSaveButton()
    }
    
    func updateSaveButton() {
        var allOk = true
        if !symbolTextField.text!.isSingleEmoji { allOk = false }
        if nameTextField.text!.count == 0 { allOk = false }
        if descriptionTextField.text!.count == 0 { allOk = false }
        if usageTextField.text!.count == 0 { allOk = false }
        if groupTextField.text!.count == 0 { allOk = false }
        
        saveButton.isEnabled = allOk
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func update(with emoji: Emoji) {
        symbolTextField.text = emoji.symbol
        nameTextField.text = emoji.name
        descriptionTextField.text = emoji.description
        usageTextField.text = emoji.usage
        groupTextField.text = emoji.group
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        emoji = Emoji(symbol: symbolTextField.text!, name: nameTextField.text!, description: descriptionTextField.text!, usage: usageTextField.text!, group: groupTextField.text!)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 16, y: 10, width: tableView.bounds.width-32, height: 25))
        headerView.backgroundColor = .clear
        let headerLabel = UILabel(frame: headerView.frame)
        headerLabel.textAlignment = .left
        headerLabel.text = captions[section]
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    

}

extension EmojiEditTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButton()
    }
}
