//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Tweet>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>
    
    var tweets = [Tweet]()
    
    let tableView: UITableView = {
        let table = UITableView()
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "cell")
        table.estimatedRowHeight = 110
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    enum Section {
        case main
    }
    
    var datasource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "OpenTweet"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Timeline", style: .plain, target: nil, action: nil)
        
        parseJSON()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        
        configureDatasource()
        updateDatasource()
    }
    
    func parseJSON() {
        
        guard let path = Bundle.main.path(forResource: "timeline", ofType: "json") else { return }
        
        let url = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: url)
            let timeline: Timeline = try JSONDecoder().decode(Timeline.self, from: jsonData)
            
            tweets = timeline.timeline
        }
        catch {
            print("Error \(error)")
            let alert = UIAlertController(
                title: "JSON Parsing Error",
                message: error.localizedDescription,
                preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
}

func configureDatasource() {
    
    datasource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath,
        model -> TimelineTableViewCell? in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TimelineTableViewCell
        cell?.configure(model: model)
        return cell
    })
}

func updateDatasource() {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.main])
    snapshot.appendItems(tweets)
    
    datasource.apply(snapshot, animatingDifferences: true, completion: nil)
}

//Mark - Tableview Delegate

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    guard let tweet = datasource.itemIdentifier(for: indexPath) else { return }
    
    let vc = DetailViewController(nibName: "DetailViewController", bundle: nil)
    vc.tweet = tweet
    vc.tweets = tweets
    navigationController?.pushViewController(vc, animated: true)
}
}


