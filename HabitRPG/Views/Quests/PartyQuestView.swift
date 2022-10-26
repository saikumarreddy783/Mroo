//
//  PartyQuestView.swift
//  Habitica
//
//  Created by Phillip Thelen on 07.05.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models

class PartyQuestView: UIView {
    
    let questImageView: NetworkImageView = {
        let imageView = NetworkImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    let backgroundView: UIView = {
        let view = UIImageView()
        view.isHidden = true
        let theme = ThemeService.shared.theme
        view.backgroundColor = theme.windowBackgroundColor
        view.cornerRadius = 12
        return view
    }()
    var progressBarViews = [QuestProgressBarView]()
    var isBossQuest = true
    
    var pendingLabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 12, weight: .semibold)
        view.textColor = .white
        view.backgroundColor = ThemeService.shared.theme.secondaryBadgeColor
        view.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(questImageView)
        addSubview(backgroundView)
        addSubview(pendingLabel)
    }
    
    func configure(state: QuestStateProtocol, quest: QuestProtocol) {
        ImageManager.getImage(name: "quest_\(quest.key ?? "")") {[weak self] (image, _) in
            self?.questImageView.image = image
            self?.setNeedsLayout()
            self?.invalidateIntrinsicContentSize()
        }
        if let boss = quest.boss {
            configureBossQuest(boss: boss, state: state)
        } else {
            configureCollectionQuest(quest: quest, state: state)
        }
        backgroundView.isHidden = false
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
    
    private func configureBossQuest(boss: QuestBossProtocol, state: QuestStateProtocol) {
        isBossQuest = true
        let bossView = progressBarViews.first ?? QuestProgressBarView()
        var newProgressBars = [bossView]
        if progressBarViews.isEmpty {
            addSubview(bossView)
            progressBarViews.append(bossView)
        }
        bossView.titleTextColor = ThemeService.shared.theme.primaryTextColor
        bossView.valueTextColor = ThemeService.shared.theme.secondaryTextColor
        bossView.barBackgroundColor = ThemeService.shared.theme.dimmedColor
        bossView.title = boss.name
        bossView.maxValue = Float(boss.health)
        bossView.barColor = UIColor.red100
        bossView.currentValue = state.progress?.health ?? 0
        bossView.bigIcon = nil
        
        if let rage = boss.rage, rage.value > 0 {
            let rageView = progressBarViews.count >= 2 ? progressBarViews[1] : QuestProgressBarView()
            newProgressBars.append(rageView)
            if progressBarViews.count < 2 {
                addSubview(rageView)
                progressBarViews.append(rageView)
            }
            
            rageView.titleTextColor = ThemeService.shared.theme.primaryTextColor
            rageView.valueTextColor = ThemeService.shared.theme.ternaryTextColor
            rageView.barBackgroundColor = ThemeService.shared.theme.dimmedColor
            rageView.title = rage.title
            rageView.maxValue = Float(rage.value)
            rageView.barColor = UIColor.orange100
            rageView.currentValue = state.progress?.rage ?? 0
            rageView.bigIcon = nil
        }
        
        if progressBarViews.count > newProgressBars.count {
            progressBarViews.forEach { (view) in
                if view != bossView {
                    view.removeFromSuperview()
                }
            }
            progressBarViews = newProgressBars
        }
    }
    
    func configureCollectionQuest(quest: QuestProtocol, state: QuestStateProtocol) {
        progressBarViews.forEach { (view) in
            view.removeFromSuperview()
        }
        progressBarViews.removeAll()
        isBossQuest = false
        quest.collect?.forEach { (questCollect) in
            let collectView = QuestProgressBarView()
            collectView.titleTextColor = ThemeService.shared.theme.primaryTextColor
            collectView.valueTextColor = ThemeService.shared.theme.ternaryTextColor
            collectView.barBackgroundColor = ThemeService.shared.theme.dimmedColor
            collectView.title = questCollect.text
            collectView.maxValue = Float(questCollect.count)
            let value = state.progress?.collect.first(where: { (collect) -> Bool in
                return collect.key == questCollect.key
            })?.count
            collectView.currentValue = Float(value ?? 0)
            collectView.barColor = UIColor.green100
            ImageManager.getImage(name: "quest_\(quest.key ?? "")_\(questCollect.key ?? "")", completion: { (image, _) in
                collectView.bigIcon = image
            })
            addSubview(collectView)
            progressBarViews.append(collectView)
        }
    }
    
    func setPendingDamage(_ pending: Float) {
        if isBossQuest {
            progressBarViews.first?.pendingBarColor = UIColor.yellow50
            progressBarViews.first?.pendingTitle = L10n.pendingDamage
            progressBarViews.first?.pendingValue = pending
        }
    }
    
    func setCollectedItems(_ pending: Int) {
        if !isBossQuest {
            pendingLabel.text = L10n.xItemsFound(pending)
            pendingLabel.isHidden = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func layout() {
        questImageView.pin.top(12).hCenter().height(questImageView.image?.size.height ?? 0)
        backgroundView.pin.top(to: questImageView.edge.bottom).marginTop(12)
        var edge = backgroundView.edge.top
        for progressView in progressBarViews {
            progressView.pin.top(to: edge).marginTop(10).start(16).end(16).height(progressView.intrinsicContentSize.height)
            edge = progressView.edge.bottom
        }
        if !pendingLabel.isHidden {
            pendingLabel.pin.top(to: edge).marginTop(10).start().end().height(28)
            edge = pendingLabel.edge.bottom
        }
        backgroundView.pin.top(to: questImageView.edge.bottom).marginTop(12).bottom(to: edge).start().end()
    }
    
    override var intrinsicContentSize: CGSize {
        layout()
        return CGSize(width: bounds.size.width, height: backgroundView.frame.origin.y + backgroundView.frame.size.height + 12)
    }
}
