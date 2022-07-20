//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate {
    
    var tweets = [Tweet]()
    
    let tableView: UITableView = {
        let table = UITableView()
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "cell")
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    enum Section {
        case main
    }
    
    var datasource: UITableViewDiffableDataSource<Section, Tweet>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseJSON()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self

        configureDatasource()
        updateDatasource()
    }
    
    func parseJSON() {
        
        guard let path = Bundle.main.path(forResource: "timeline", ofType: "json") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            let timeline: Timeline = try JSONDecoder().decode(Timeline.self, from: jsonData)
    
            tweets = timeline.timeline
        }
        catch {
            print("Error \(error)")
        }
    }
    
    func configureDatasource() {
        
        datasource = UITableViewDiffableDataSource<Section, Tweet>(tableView: tableView, cellProvider: { tableView, indexPath, model -> TimelineTableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TimelineTableViewCell
            cell?.configure(model: model)
            return cell
        })
    }
    
    func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(tweets)
        
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

