//
//  RepliedTweetView.swift
//  OpenTweet
//
//  Created by Derrick Turner on 7/25/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import UIKit

@IBDesignable

final class RepliedTweetView: UIView {
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "RepliedTweetView") else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func configureView(model: Tweet) {
        
        self.avatarImage.imageFromURL(urlString: model.avatar)
        self.authorLabel.text = model.author
        self.contentLabel.text = model.content
        self.timeLabel.text = model.getFormattedDate()
        
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.height/2
        self.authorLabel.font = Helvetica.bold.of(size: 17)
        self.contentLabel.font = Helvetica.regular.of(size: 15)
        self.contentLabel.highlight(text: model.content)
        self.contentLabel.numberOfLines = 0
        self.timeLabel.font = Helvetica.light.of(size: 12)
    }
}
