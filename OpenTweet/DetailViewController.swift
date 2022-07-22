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
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet?
    var tweets = [Tweet]()
    
    var tableData = [Tweet]()
    
    enum Section {
        case main
    }
    
    var datasource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tweet"
        
        updateDetails()
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
    
    func updateDetails() {
        
        guard let item = tweet else { return }
        
        if let urlString = item.avatar {
            if let url = URL(string: urlString) {
                ImageDownloader().getImage(withURL: url) { [weak self] image in
                    self?.avatarImage.image = image
                }
            }
        } else {
            avatarImage.image = UIImage(named: "Generic")
        }
        
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
        
        datasource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> TimelineTableViewCell? in
            
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = tableData.count > 0 ? "Replies" : ""
        let label = UILabel()
        label.font = Helvetica.bold.of(size: 17)
        label.textAlignment = .center
        label.text = title
        return label
    }
}
