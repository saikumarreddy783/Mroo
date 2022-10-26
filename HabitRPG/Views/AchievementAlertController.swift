//
//  AchievementAlertController.swift
//  Habitica
//
//  Created by Phillip Thelen on 25.06.20.
//  Copyright © 2020 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models

class AchievementAlertController: HabiticaAlertController {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 6
        return view
    }()
    private let iconStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 16
        return view
    }()
    private let iconView: NetworkImageView = {
        let view = NetworkImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 56))
        return view
    }()
    private let achievementTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let spacerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 14))
        view.backgroundColor = .clear
        return view
    }()
    private let leftSparkleView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 56))
        view.image = Asset.sparkleStarsLeft.image
        return view
    }()
    private let rightSparkleView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 56))
        view.image = Asset.sparkleStarsRight.image
        return view
    }()
    
    private var isOnboarding = false
    private var isLastOnboardingAchievement = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init() {
        super.init()
        title = L10n.youGotAchievement
        setupView()
    }
    
    private func setupView() {
        contentView = stackView
        stackView.addArrangedSubview(iconStackView)
        iconStackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(spacerView)
        spacerView.addHeightConstraint(height: 14)
        stackView.addArrangedSubview(achievementTitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    override func applyTheme(theme: Theme) {
        super.applyTheme(theme: theme)
        descriptionLabel.textColor = theme.ternaryTextColor
    }
    
    func setNotification(notification: NotificationProtocol, isOnboarding: Bool, isLastOnboardingAchievement: Bool) {
        self.isOnboarding = isOnboarding
        self.isLastOnboardingAchievement = isLastOnboardingAchievement
        var key = notification.type.rawValue
        if notification.type == HabiticaNotificationType.achievementGeneric {
            key = notification.achievementKey ?? ""
        }
        switch key {
        case HabiticaNotificationType.achievementPartyUp.rawValue:
            configureAlert(title: L10n.partyUpTitle, text: L10n.partyUpDescription, iconName: "partyUp")
        case HabiticaNotificationType.achievementPartyOn.rawValue:
            configureAlert(title: L10n.partyOnTitle, text: L10n.partyOnDescription, iconName: "partyOn")
        case HabiticaNotificationType.achievementBeastMaster.rawValue:
            configureAlert(title: L10n.beastMasterTitle, text: L10n.beastMasterDescription, iconName: "rat")
        case HabiticaNotificationType.achievementMountMaster.rawValue:
            configureAlert(title: L10n.mountMasterTitle, text: L10n.mountMasterDescription, iconName: "wolf")
        case HabiticaNotificationType.achievementTriadBingo.rawValue:
            configureAlert(title: L10n.triadBingoTitle, text: L10n.triadBingoDescription, iconName: "triadbingo")
        case HabiticaNotificationType.achievementGuildJoined.rawValue:
            configureAlert(title: L10n.guildJoinedTitle, text: L10n.guildJoinedDescription, iconName: "guild")
        case HabiticaNotificationType.achievementChallengeJoined.rawValue:
            configureAlert(title: L10n.challengeJoinedTitle, text: L10n.challengeJoinedDescription, iconName: "challenge")
            
        case HabiticaNotificationType.achievementAllYourBase.rawValue,
             HabiticaNotificationType.achievementBackToBasics.rawValue,
             HabiticaNotificationType.achievementJustAddWater.rawValue,
             HabiticaNotificationType.achievementLostMasterclasser.rawValue,
             HabiticaNotificationType.achievementMindOverMatter.rawValue,
             HabiticaNotificationType.achievementDustDevil.rawValue,
             HabiticaNotificationType.achievementAridAuthority.rawValue,
             HabiticaNotificationType.achievementMonsterMagus.rawValue,
             HabiticaNotificationType.achievementMonsterMagus.rawValue,
             HabiticaNotificationType.achievementUndeadUndertaker.rawValue,
             HabiticaNotificationType.achievementPrimedForPainting.rawValue,
             HabiticaNotificationType.achievementPearlyPro.rawValue,
             HabiticaNotificationType.achievementTickledPink.rawValue,
             HabiticaNotificationType.achievementRosyOutlook.rawValue,
             HabiticaNotificationType.achievementBugBonanza.rawValue,
             HabiticaNotificationType.achievementBareNecessities.rawValue,
             HabiticaNotificationType.achievementFreshwaterFriends.rawValue,
             HabiticaNotificationType.achievementGoodAsGold.rawValue,
             HabiticaNotificationType.achievementAllThatGlitters.rawValue,
             HabiticaNotificationType.achievementBoneCollector.rawValue,
             HabiticaNotificationType.achievementSkeletonCrew.rawValue:
            configureAlert(title: notification.achievementMessage ?? "", text: notification.achievementModalText ?? "", iconName: notification.achievementKey ?? "")
            
        case HabiticaNotificationType.achievementInvitedFriend.rawValue:
            configureAlert(title: L10n.invitedFriendTitle, text: L10n.invitedFriendDescription, iconName: "friends")
        case "createdTask":
            configureAlert(title: L10n.createdTaskTitle, text: L10n.createdTaskDescription, iconName: "createdTask")
        case "completedTask":
            configureAlert(title: L10n.completedTaskTitle, text: L10n.completedTaskDescription, iconName: "completedTask")
        case "hatchedPet":
            configureAlert(title: L10n.hatchedPetTitle, text: L10n.hatchedPetDescription, iconName: "hatchedPet")
        case "fedPet":
            configureAlert(title: L10n.fedPetTitle, text: L10n.fedPetDescription, iconName: "fedPet")
        case "purchasedEquipment":
            configureAlert(title: L10n.purchasedEquipmentTitle, text: L10n.purchasedEquipmentDescription, iconName: "purchasedEquipment")
        case HabiticaNotificationType.achievementOnboardingComplete.rawValue:
            title = L10n.onboardingCompleteAchievementTitle
            configureAlert(title: L10n.onboardingCompleteTitle, text: L10n.onboardingCompleteDescription, iconName: "onboardingComplete")
        default:
            break
        }
    }
    
    private func configureAlert(title: String, text: String, iconName: String) {
        if iconName == "onboardingComplete" {
            iconView.image = Asset.onboardingDoneArt.image
            iconView.contentMode = .center
            iconStackView.addHeightConstraint(height: 90)
        } else {
            iconStackView.insertArrangedSubview(leftSparkleView, at: 0)
            iconView.setImagewith(name: "achievement-\(iconName)2x")
            iconStackView.addArrangedSubview(rightSparkleView)
        }
        descriptionLabel.text = text
        descriptionLabel.textColor = ThemeService.shared.theme.primaryTextColor
        if iconName == "onboardingComplete" {
            let attrString = NSMutableAttributedString(string: title)
            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: ThemeService.shared.theme.primaryTextColor, range: NSRange(location: 0, length: attrString.length))
            attrString.addAttributesToSubstring(string: L10n.fiveAchievements, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ])
            attrString.addAttributesToSubstring(string: L10n.hundredGold, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.yellow10
            ])
            achievementTitleLabel.attributedText = attrString
        } else {
            achievementTitleLabel.text = title
            achievementTitleLabel.textColor = ThemeService.shared.theme.primaryTextColor
        }
        let titleSize = achievementTitleLabel.sizeThatFits(CGSize(width: 240, height: 600))
        achievementTitleLabel.addHeightConstraint(height: titleSize.height)
        let size = descriptionLabel.sizeThatFits(CGSize(width: 240, height: 600))
        descriptionLabel.addHeightConstraint(height: size.height)
        
        containerViewSpacing = 12
        
        if isOnboarding {
            addAction(title: L10n.onwards, isMainAction: true)
            if !isLastOnboardingAchievement {
                addAction(title: L10n.viewOnboardingTasks) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        RouterHandler.shared.handle(urlString: "/user/onboarding")
                    }
                }
            }
        } else if iconName == "onboardingComplete" {
            addAction(title: L10n.viewAchievements, isMainAction: true) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    RouterHandler.shared.handle(urlString: "/user/achievements")
                }
            }
            addCloseAction()
        } else {
            addAction(title: L10n.onwards, isMainAction: true)
            if !isLastOnboardingAchievement {
                addAction(title: L10n.viewAchievements) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        RouterHandler.shared.handle(urlString: "/user/achievements")
                    }
                }
            }
        }

        stackView.setNeedsUpdateConstraints()
        stackView.setNeedsLayout()
        view.setNeedsLayout()
    }
}
