//
//  UserTopHeader.swift
//  Habitica
//
//  Created by Phillip Thelen on 09.03.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models
import ReactiveSwift
import Habitica_Database
import PinLayout

class UserTopHeader: UIView, Themeable {
    
    @IBOutlet weak var avatarView: AvatarView!
    
    @IBOutlet weak var healthLabel: LabeledProgressBar!
    @IBOutlet weak var experienceLabel: LabeledProgressBar!
    @IBOutlet weak var magicLabel: LabeledProgressBar!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var buffIconView: UIImageView!
    
    @IBOutlet weak var classImageView: UIImageView!
    
    @IBOutlet weak var gemView: CurrencyCountView!
    @IBOutlet weak var goldView: CurrencyCountView!
    @IBOutlet weak var hourglassView: CurrencyCountView!
    
    @IBOutlet weak var healthLabelAvatarSpacing: NSLayoutConstraint!
    @IBOutlet weak var experienceLabelAvatarSpacing: NSLayoutConstraint!
    @IBOutlet weak var magicLabelAvatarSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var avatarLeadingSpacing: NSLayoutConstraint!
    
    private var contributorTier: Int = 0 {
        didSet {
            if contributorTier > 0 {
                usernameLabel.textColor = UIColor.contributorColor(forTier: contributorTier)
                levelLabel.textColor = UIColor.contributorColor(forTier: contributorTier)
            } else {
                usernameLabel.textColor = ThemeService.shared.theme.primaryTextColor
                levelLabel.textColor = ThemeService.shared.theme.primaryTextColor
            }
        }
    }
    
    private let repository = UserRepository()
    private let disposable = ScopedDisposable(CompositeDisposable())
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        healthLabel.icon = HabiticaIcons.imageOfHeartLightBg
        experienceLabel.icon = HabiticaIcons.imageOfExperience
        magicLabel.icon = HabiticaIcons.imageOfMagic
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            healthLabel.fontSize = 13
            experienceLabel.fontSize = 13
            magicLabel.fontSize = 13
        } else {
            healthLabel.fontSize = 11
            experienceLabel.fontSize = 11
            magicLabel.fontSize = 11
        }
        
        configureAccessibilitySizing()
        
        buffIconView.image = HabiticaIcons.imageOfBuffIcon
        
        goldView.currency = .gold
        gemView.currency = .gem
        hourglassView.currency = .hourglass
        
        gemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showGemView)))
        
        usernameLabel.font = UIFontMetrics.default.scaledSystemFont(ofSize: 15)
        levelLabel.font = UIFontMetrics.default.scaledSystemFont(ofSize: 11)
        usernameLabel.adjustsFontForContentSizeCategory = true
        levelLabel.adjustsFontForContentSizeCategory = true
        
        disposable.inner.add(repository.getUser().on(value: {[weak self] user in
            self?.set(user: user)
        }).start())
        
        ThemeService.shared.addThemeable(themable: self)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        NotificationCenter.default.addObserver(self, selector: #selector(preferredContentSizeChanged(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func removeFromSuperview() {
        NotificationCenter.default.removeObserver(self)
        super.removeFromSuperview()
    }
    
    @objc
    func preferredContentSizeChanged(_ notification: Notification) {
        configureAccessibilitySizing()
        
        goldView.invalidateIntrinsicContentSize()
        gemView.invalidateIntrinsicContentSize()
        hourglassView.invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    private func configureAccessibilitySizing() {
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory && healthLabel.type != "Hp" {
            healthLabel.type = "Hp"
            experienceLabel.type = "Exp"
            magicLabel.type = "Mp"
        } else if !traitCollection.preferredContentSizeCategory.isAccessibilityCategory && healthLabel.type != L10n.health {
            healthLabel.type = L10n.health
            experienceLabel.type = L10n.experience
            magicLabel.type = L10n.mana
        }
        
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory && healthLabelAvatarSpacing.constant != 10 {
            healthLabelAvatarSpacing.constant = 10
            experienceLabelAvatarSpacing.constant = 10
            magicLabelAvatarSpacing.constant = 10
            avatarLeadingSpacing.constant = 12
        } else if !traitCollection.preferredContentSizeCategory.isAccessibilityCategory && healthLabelAvatarSpacing.constant != 25 {
            healthLabelAvatarSpacing.constant = 25
            experienceLabelAvatarSpacing.constant = 25
            magicLabelAvatarSpacing.constant = 25
            avatarLeadingSpacing.constant = 22
        }
    }
    
    func applyTheme(theme: Theme) {
        theme.applyBackgroundColor(views: [
            self,
            classImageView,
            usernameLabel,
            levelLabel,
            hourglassView,
            gemView,
            goldView
            ], color: theme.contentBackgroundColor)
        healthLabel.textColor = theme.secondaryTextColor
        healthLabel.backgroundColor = theme.contentBackgroundColor
        healthLabel.progressBar.barBackgroundColor = theme.contentBackgroundColorDimmed
        experienceLabel.textColor = theme.secondaryTextColor
        experienceLabel.backgroundColor = theme.contentBackgroundColor
        experienceLabel.progressBar.barBackgroundColor = theme.contentBackgroundColorDimmed
        magicLabel.textColor = theme.secondaryTextColor
        magicLabel.backgroundColor = theme.contentBackgroundColor
        magicLabel.progressBar.barBackgroundColor = theme.contentBackgroundColorDimmed
        
        if theme.isDark {
            healthLabel.color = UIColor.red50.withAlphaComponent(0.75)
            experienceLabel.color = UIColor.yellow50.withAlphaComponent(0.75)
            magicLabel.color = UIColor.blue50.withAlphaComponent(0.75)
            healthLabel.iconView.alpha = 0.8
            experienceLabel.iconView.alpha = 0.8
            magicLabel.iconView.alpha = 0.8
            classImageView.alpha = 0.8
        } else {
            healthLabel.color = UIColor.red100
            experienceLabel.color = UIColor.yellow100
            magicLabel.color = UIColor.blue100
            healthLabel.iconView.alpha = 1.0
            experienceLabel.iconView.alpha = 1.0
            magicLabel.iconView.alpha = 1.0
            classImageView.alpha = 1.0
        }
        let tier = contributorTier
        contributorTier = tier
        goldView.updateStateValues()
        gemView.updateStateValues()
        hourglassView.updateStateValues()
    }
    
    private func set(user: UserProtocol) {
        if !user.isValid {
            return
        }
        avatarView.avatar = AvatarViewModel(avatar: user)
        if let stats = user.stats {
            healthLabel.value = stats.health
            if stats.maxHealth > 0 {
                healthLabel.maxValue = stats.maxHealth
            }
            experienceLabel.value = stats.experience
            if stats.toNextLevel > 0 {
                experienceLabel.maxValue = stats.toNextLevel
            }
            
            configureMagicBar(user: user)
            
            let levelString = L10n.level
            usernameLabel.text = "\(levelString) \(stats.level)"
            configureClassDisplay(user: user)
            goldView.amount = Int(stats.gold)
            goldView.textColor = UIColor("#626B74")
            
            buffIconView.isHidden = stats.buffs?.isBuffed != true
            layoutBuffIcon()
        }
        contributorTier = user.contributor?.level ?? 0
        gemView.amount = user.gemCount
        gemView.textColor = UIColor("#626B74")
        
        if let hourglasses = user.purchased?.subscriptionPlan?.consecutive?.hourglasses {
            hourglassView.isHidden = !(hourglasses > 0 || user.isSubscribed)
            hourglassView.amount = hourglasses
            hourglassView.textColor = UIColor("#626B74")
        } else {
            hourglassView.isHidden = true
        }
        
        setNeedsLayout()
    }
 
    private func configureMagicBar(user: UserProtocol) {
        guard let stats = user.stats else {
            return
        }
        if stats.level >= 10 && user.preferences?.disableClasses != true {
            magicLabel.value = stats.mana
            if stats.maxMana > 0 {
                magicLabel.maxValue = stats.maxMana
            }
            magicLabel.isActive = true
            magicLabel.isHidden = false
        } else {
            if user.preferences?.disableClasses == true && user.flags?.classSelected != false {
                magicLabel.isHidden = true
            } else {
                magicLabel.isHidden = false
                magicLabel.isActive = false
                magicLabel.value = 0
                if stats.level >= 10 {
                    magicLabel.labelView.text = L10n.unlocksSelectingClass
                } else {
                    magicLabel.labelView.text = L10n.unlocksLevelTen
                }
            }
        }
    }
    
    private func configureClassDisplay(user: UserProtocol) {
        if user.preferences?.disableClasses != true && (user.stats?.level ?? 0) >= 10 {
            levelLabel.text = user.stats?.habitClassNice?.capitalized
            switch user.stats?.habitClass ?? "" {
            case "warrior":
                classImageView.image = HabiticaIcons.imageOfWarriorLightBg
            case "wizard":
                classImageView.image = HabiticaIcons.imageOfMageLightBg
            case "Doctor":
                classImageView.image = HabiticaIcons.imageOfHealerLightBg
            case "Fighter":
                classImageView.image = HabiticaIcons.imageOfRogueLightBg
            default:
                classImageView.image = nil
            }
            classImageView.isHidden = false
        } else {
            classImageView.image = nil
            classImageView.isHidden = true
            levelLabel.text = nil
        }
    }
    
    @objc
    private func showGemView() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBuffIcon()
    }
    
    private func layoutBuffIcon() {
        let usernameLabelSize = usernameLabel.sizeThatFits(levelLabel.bounds.size)
        buffIconView.pin.size(15).start(usernameLabelSize.width + 6).top((usernameLabelSize.height - 15)/2)
    }
}
