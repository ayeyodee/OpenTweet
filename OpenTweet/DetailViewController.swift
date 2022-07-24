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
    
    //In Reply To Tweets Properties
    @IBOutlet weak var inReplyToView: UIView!
    @IBOutlet weak var irtAvatarImage: UIImageView!
    @IBOutlet weak var irtAuthorLabel: UILabel!
    @IBOutlet weak var irtContentLabel: UILabel!
    @IBOutlet weak var irtTimeLabel: UILabel!
    
    //Selected Tweets Properties
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
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
    
    func updateInReplyTo(tweet: Tweet) {
        
        irtAvatarImage.imageFromURL(urlString: tweet.avatar)
        irtAuthorLabel.text = tweet.author
        irtContentLabel.text = tweet.content
        irtTimeLabel.text = tweet.getFormattedDate()
        
        irtAvatarImage.layer.cornerRadius = irtAvatarImage.frame.height/2
        irtAuthorLabel.font = Helvetica.bold.of(size: 17)
        irtContentLabel.font = Helvetica.regular.of(size: 15)
        irtContentLabel.highlight(text: tweet.content)
        irtContentLabel.numberOfLines = 0
        irtTimeLabel.font = Helvetica.light.of(size: 12)
    }
    
    func updateSelectedTweet() {
        
        guard let item = tweet else { return }
        
        if let reply = item.inReplyTo {
            if let tweet = tweets.first(where: {$0.id == reply}) {
                updateInReplyTo(tweet: tweet)
            }
        } else {
            inReplyToView.isHidden = true
        }
        
        avatarImage.imageFromURL(urlString: item.avatar)
        authorLabel.text = item.author
        contentLabel.text = item.content
        contentLabel.highlight(text: item.content)
        contentLabel.isUserInteractionEnabled = true
        contentLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(handleTapOnLabel(_:))))
        contentLabel.numberOfLines = 0
        timeLabel.text = item.getFormattedDate()
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        authorLabel.font = Helvetica.bold.of(size: 12)
        contentLabel.font = Helvetica.regular.of(size: 18)
        timeLabel.font = Helvetica.light.of(size: 12)
    }
    
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = contentLabel.attributedText?.string else { return }
        
        let types: NSTextCheckingResult.CheckingType = .link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        matches?.forEach {
            if let range = Range($0.range, in: text),
               recognizer.didTapAttributedTextInLabel(label: contentLabel, inRange: NSRange(range, in: text)) {
                let url = text[range]
                if let url = URL(string: String(url)) {
                    UIApplication.shared.open(url)
                }
            }
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
