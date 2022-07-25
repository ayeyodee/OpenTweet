//
//  DetailViewController.swift
//  OpenTweet
//
//  Created by Derrick Turner on 7/21/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Tweet>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>
    
    @IBOutlet weak var repliedTweetView: RepliedTweetView!
    @IBOutlet weak var detailTweetView: DetailTweetView!
    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet?
    var inReplayToTweet: Tweet?
    var tweets = [Tweet]()
    
    var tableData = [Tweet]()
    
    enum Section {
        case main
    }
    
    var datasource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tweet"
        
        updateSelectedTweet()
        configureDatasource()
        updateDatasource()
    }
    
    func repliedTweets() {
        
        guard let item = tweet else { return }
        
        for reply in tweets {
            if reply.inReplyTo == item.id {
                tableData.append(reply)
            }
        }
    }
    
    func updateSelectedTweet() {
        
        guard let item = tweet else { return }
        
        if let reply = item.inReplyTo {
            if let tweet = tweets.first(where: {$0.id == reply}) {
                repliedTweetView.configureView(model: tweet)
            }
        } else {
            repliedTweetView.isHidden = true
        }
        
        detailTweetView.configureView(model: item)
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
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
        
        repliedTweets()
        snapshot.appendSections([.main])
        snapshot.appendItems(tableData)
        
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tweet = datasource.itemIdentifier(for: indexPath) else { return }
        
        let vc = DetailViewController(nibName: "DetailViewController", bundle: nil)
        vc.tweet = tweet
        vc.tweets = tweets
        navigationController?.pushViewController(vc, animated: true)
    }
}
