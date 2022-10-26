//
//  ChallengeDetailHeaderView.swift
//  Habitica
//
//  Created by Phillip Thelen on 01/03/2017.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

import UIKit
import Down
import Habitica_Models

class ChallengeDetailHeaderView: UIView {

    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var notesLabel: UITextView!
    @IBOutlet weak private var memberCountLabel: UILabel!
    @IBOutlet weak private var gemCountLabel: UILabel!
    var showMoreAction: (() -> Void)?

    @IBAction func showMoreTapped(_ sender: Any) {
        if let action = self.showMoreAction {
            action()
        }
    }

    func set(challenge: ChallengeProtocol) {
        notesLabel.textContainer.maximumNumberOfLines = 5
        notesLabel.textContainer.lineBreakMode = .byTruncatingTail

        nameLabel.text = challenge.name?.unicodeEmoji
        if let notes = challenge.notes {
            notesLabel.attributedText = try? Down(markdownString: notes.unicodeEmoji).toHabiticaAttributedString()
        }
        memberCountLabel.text = String(challenge.memberCount)
        gemCountLabel.text = String(challenge.prize)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        var height = size.height
        let width = size.width
        height += nameLabel.intrinsicContentSize.height + 8
        height += notesLabel.intrinsicContentSize.height + 8
        height += 38
        return CGSize(width: width, height: height)
    }
}
