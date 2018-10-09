//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Denis Bystruev on 08/10/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    
    var emojis: [Emoji] = [
        Emoji(symbol: "🐢", name: "Черепаха", description: "Зелёная черепаха", usage: "медленное движение", group: "Животные"),
        Emoji(symbol: "🐰", name: "Заяц", description: "Заяц с ушами", usage: "быстрое движение", group: "Животные"),
        Emoji(symbol: "🐱", name: "Кошка", description: "Жёлтый кот", usage: "хитрое поведение", group: "Животные"),
        Emoji(symbol: "🐶", name: "Собака", description: "Типичный пёс", usage: "открытое поведение", group: "Животные"),
        Emoji(symbol: "😀", name: "Смайлик", description: "Улыбающаяся мордочка", usage: "полное счастье", group: "Смайлики"),
        Emoji(symbol: "😇", name: "Ангел", description: "Мордочка с нимбом", usage: "хорошие поступки", group: "Смайлики"),
        Emoji(symbol: "😍", name: "Влюблённый", description: "Влюблённая мордочка", usage: "состояние влюблённости", group: "Смайлики"),
        Emoji(symbol: "🇧🇾", name: "Беларусь", description: "Флаг Республики Беларусь", usage: "для парада", group: "Флаги"),
        Emoji(symbol: "🇷🇺", name: "Россия", description: "Флаг России", usage: "символ государства", group: "Флаги")
    ]
    
    var groups: [String] {
        var groups = Set<String>()
        
        for emoji in emojis {
            groups.insert(emoji.group)
        }
        
        return groups.sorted()
    }
    

    func emojis(for group: String) -> [Emoji] {
        return emojis.filter({$0.group == group})
    }
    
    func absoluteIndex(of emoji: Emoji)->Int? {
        for (index, element) in emojis.enumerated() {
            if element === emoji { return index}
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return emojis.count
//        } else {
//            // not implemented
//            return 0
//        }
        return emojis(for: groups[section]).count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiTableViewCell", for: indexPath) as! EmojiTableViewCell

        let emojis_g = emojis(for: groups[indexPath.section])
        let emoji = emojis_g[indexPath.row]
        
        cell.update(with: emoji)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedEmoji = emojis(for: groups[sourceIndexPath.section])[sourceIndexPath.row]
        
        var destinationIndex: Int?
        
        if destinationIndexPath.row > emojis(for: groups[destinationIndexPath.section]).count-1 {
            if destinationIndexPath.section < groups.count-1 {
                let targetEmoji = emojis(for: groups[destinationIndexPath.section+1])[0]
                destinationIndex = absoluteIndex(of: targetEmoji)!
            }
        } else {
            let targetEmoji = emojis(for: groups[destinationIndexPath.section])[destinationIndexPath.row]
            destinationIndex = absoluteIndex(of: targetEmoji)!
        }
        
        let sourceIndex = absoluteIndex(of: movedEmoji)!
        
        if sourceIndexPath.section != destinationIndexPath.section {
            movedEmoji.group = groups[destinationIndexPath.section]
        }
        
        
        emojis.remove(at: sourceIndex)
        if let destinationIndex = destinationIndex {
            emojis.insert(movedEmoji, at: destinationIndex)
        } else {
            emojis.append(movedEmoji)
        }
        
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            emojis.remove(at: absoluteIndex(of: emojis(for: groups[indexPath.section])[indexPath.row])!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditEmoji",
            let selectedRow = tableView.indexPathForSelectedRow {
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! EmojiEditTableViewController
            vc.emoji = emojis(for: groups[selectedRow.section])[selectedRow.row]
        }
    }

    
    @IBAction func unwindToEmodjiTable(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceVC = segue.source as? EmojiEditTableViewController
        else { return }
        
        if let emodji = sourceVC.emoji {
            if let selectedRow = tableView.indexPathForSelectedRow {
                let row = absoluteIndex(of: emojis(for: groups[selectedRow.section])[selectedRow.row])!
                emojis[row] = emodji
            } else {
                emojis.append(emodji)
            }
            tableView.reloadData()
        }
        
    }
    
    
 

}
