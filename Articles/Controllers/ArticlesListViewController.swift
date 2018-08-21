//
//  HistoryViewController.swift
//  PicRecognition
//
//  Created by Anna on 8/4/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class ArticlesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let endpoint = "http://madiosgames.com/api/v1/application/ios_test_task/articles"
    var articles = [Article]()
    var records = [NSManagedObject]()
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: Bundle.main), forCellReuseIdentifier: "ArticleCell")
        if let backgroundImage = UIImage(named:"background") {
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        }
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        editButton.title = "Edit"
        
//        CDPersistence.resetAllRecords()
        
        records = CDPersistence.fetchRecords()
        if records.count == 0 {
            fetchArticles()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    
    func fetchArticles() {
        Network.request(api: "/api/v1/application/ios_test_task/articles", method: "GET", completion: { (jsonArray) in
            guard let jsonArray = jsonArray as? [[String:AnyObject]] else { return }
            for index in 0..<jsonArray.count {
                let json = jsonArray[index]
                guard   let id = json["id"] as? Int,
                    let title = json["title"] as? String,
                    let imageMediumPath = json["image_medium"] as? String,
                    let imageThumbPath = json["image_thumb"] as? String,
                    let urlPath = json["content_url"] as? String else { return }
                let article = Article(id: id, title: title, imageMediumPath: imageMediumPath, imageThumbPath: imageThumbPath, urlPath: urlPath)
                DispatchQueue.main.async {
                    CDPersistence.save(article: article, index: index)
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.records = CDPersistence.fetchRecords()
                self.tableView.reloadData()
            }
        }) { (error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let vc = segue.destination as? DetailsViewController,
            let index = selectedIndex,
            let urlPath = records[index].value(forKey: "urlPath") as? String {
            vc.url = URL(string: urlPath)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }


    @IBAction func edit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        let buttonTitle = tableView.isEditing ? "Done" : "Edit"
        editButton.title = buttonTitle
    }
}

extension ArticlesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCell
        let record = records[indexPath.row]
        cell.record = record
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.iPad() ? 300 : 100
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingRecord = records[sourceIndexPath.row]
        records.remove(at: sourceIndexPath.row)
        records.insert(movingRecord, at: destinationIndexPath.row)
        records.forEach { (record) in
            if let index = records.index(of: record), let title = record.value(forKey: "title") as? String {
                CDPersistence.updateRecord(index: index, title: title)
            }
        }
        do {
            try movingRecord.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}
