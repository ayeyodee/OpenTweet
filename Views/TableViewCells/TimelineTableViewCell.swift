//
//  TimelineTableViewCell.swift
//  OpenTweet
//
//  Created by Derrick Turner on 7/18/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            })
        }
    }
    
    func configure(model: Tweet) {
        
        avatarImage.imageFromURL(urlString: model.avatar)
        authorLabel.text = model.author
        contentLabel.text = model.content
        contentLabel.numberOfLines = 0
        contentLabel.highlight(text: model.content)
        timeLabel.text = model.getFormattedDate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImage.image = UIImage(named: "Generic")
        authorLabel.text = nil
        contentLabel.text = nil
        timeLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        authorLabel.font = Helvetica.bold.of(size: 17)
        contentLabel.font = Helvetica.regular.of(size: 15)
        timeLabel.font = Helvetica.light.of(size: 12)
    }
    
}
