//
//  ShopViewController.swift
//  Habitica
//
//  Created by Phillip Thelen on 20.08.21.
//  Copyright © 2021 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models

class ShopViewController: BaseCollectionViewController, ShopCollectionViewDataSourceDelegate {
    func showGearSelection(sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for title in ["warrior", "Builder", "Doctor", "Fighter", "none"] {
            let action = UIAlertAction(title: title.localizedCapitalized, style: .default) {[weak self] _ in
                self?.selectedGearCategory = title
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction.cancelAction())
        alertController.popoverPresentationController?.sourceView = sourceView
        alertController.popoverPresentationController?.sourceRect = sourceView.bounds
        present(alertController, animated: true, completion: nil)
    }
    
    func updateShopHeader(shop: ShopProtocol?) {
        bannerView.shop = shop
    }
    
    func updateNavBar(gold: Int, gems: Int, hourglasses: Int) {
        goldView.amount = gold
        gemView.amount = gems
        hourglassView.amount = hourglasses
    }
    
    var shopIdentifier: String?
    
    private lazy var bannerView: NPCBannerView = {
        return NPCBannerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 156))
    }()
    private var dataSource: ShopCollectionViewDataSource?
    private var selectedIndex: NSIndexPath?
    private var insetWasSetup: Bool?
    private var selectedGearCategory: String? {
        didSet {
            dataSource?.selectedGearCategory = selectedGearCategory
        }
    }
    private var hourglassView = CurrencyCountView(currency: .hourglass)
    private var gemView = CurrencyCountView(currency: .gem)
    private var goldView = CurrencyCountView(currency: .gold)
    
    var topHeaderSubView: Bool = false
    override func viewDidLoad() {
        //        topHeaderSubView = (navigationController?.viewControllers.count == 1)
        //        super.viewDidLoad()
        //        if topHeaderSubView {
        //            shopIdentifier = Constants.MarketKey
        //            topHeaderCoordinator?.scrollView?.addSubview(bannerView)
        //        } else {
        //            topHeaderCoordinator?.alternativeHeader = bannerView
        //        }
        //
        //        if let identifier = shopIdentifier {
        //            bannerView.setSprites(identifier: identifier)
        //            bannerView.setNPCName(identifier: identifier)
        //        }
        //
        //        setupNavBar()
        //        setupCollectionView()
        //
        //        dataSource?.selectedGearCategory = selectedGearCategory
        //        dataSource?.needsGearSection = shopIdentifier == "market"
        //        //dataSource?.extraHeight = topHeaderSubView ? bannerView.frame.height : 0
        //
        //        refresh()
        //
        //        // for shop
        //        tutorialIdentifier = "rewards"
        topHeaderSubView = (navigationController?.viewControllers.count == 1)
        super.viewDidLoad()
        if topHeaderSubView {
            shopIdentifier = Constants.MarketKey
            // topHeaderCoordinator?.scrollView?.addSubview(bannerView)
            topHeaderCoordinator?.alternativeHeader = bannerView
        } else {
            topHeaderCoordinator?.alternativeHeader = bannerView
        }
        if let identifier = shopIdentifier {
            bannerView.setSprites(identifier: identifier)
            bannerView.setNPCName(identifier: identifier)
        }
        
        setupNavBar()
        setupCollectionView()
        
        dataSource?.selectedGearCategory = selectedGearCategory
        dataSource?.needsGearSection = shopIdentifier == "market"
        // dataSource?.extraHeight = topHeaderSubView ? bannerView.frame.height : 0
        
        refresh()
        
        // for shop
        tutorialIdentifier = "rewards"
    }
    
    override func getDefinitionFor(tutorial: String) -> [String] {
        if tutorial == self.tutorialIdentifier {
            return [L10n.Tutorials.rewards1, L10n.Tutorials.rewards2]
        }
        return []
    }
    
    private func setupNavBar() {
        if topHeaderSubView {
            navigationItem.title = "Market"
            /*let button = UIButton()
             button.setImage(UIImage(named: "ic_round-menu"), for: .normal)
             button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
             navigationItem.leftBarButtonItems = [
             UIBarButtonItem(customView: button)
             ]
             
             satusView.axis  = NSLayoutConstraint.Axis.horizontal
             satusView.distribution  = UIStackView.Distribution.equalSpacing
             satusView.alignment = UIStackView.Alignment.center
             satusView.spacing = 8.0
             
             
             label.text = "Active"
             label.sizeToFit()
             satusView.addArrangedSubview(label)
             
             switchView.isOn = true
             switchView.addTarget(self, action: #selector(statusChange(_:)), for: .valueChanged)
             satusView.addArrangedSubview(switchView)
             satusView.translatesAutoresizingMaskIntoConstraints = false
             navigationItem.rightBarButtonItems = [
             UIBarButtonItem(customView: satusView)
             ]*/
        } else {
            if shopIdentifier == "timeTravelersShop" {
                hourglassView.currency = .hourglass
                navigationItem.rightBarButtonItems = [
                    UIBarButtonItem(customView: hourglassView)
                ]
            } else {
                gemView.currency = .gem
                goldView.currency = .gold
                navigationItem.rightBarButtonItems = [
                    UIBarButtonItem(customView: gemView),
                    UIBarButtonItem(customView: goldView)
                ]
            }
        }
    }
    
    @objc func openMenu() {
        let secondStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = secondStoryBoard.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "InAppRewardCell", bundle: nibBundle), forCellWithReuseIdentifier: "ItemCell")
        guard let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        collectionViewLayout.itemSize = CGSize(width: 90, height: 120)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 20, right: 6)
        collectionView.collectionViewLayout = collectionViewLayout
        
        if let identifier = shopIdentifier {
            if identifier == "timeTravelersShop" {
                dataSource = TimeTravelersCollectionViewDataSource(identifier: identifier, delegate: self)
            } else {
                dataSource = ShopCollectionViewDataSource(identifier: identifier, delegate: self)
            }
        }
        
        dataSource?.collectionView = collectionView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource?.dispose()
    }
    
    private func refresh() {
        dataSource?.retrieveShopInventory(nil)
    }
    
    func didSelectItem(_ item: InAppRewardProtocol?) {
        let viewController = StoryboardScene.BuyModal.hrpgBuyItemModalViewController.instantiate()
        viewController.reward = item
        viewController.shopIdentifier = shopIdentifier
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        viewController.shopViewController = self
        if let controller = tabBarController ?? navigationController {
            controller.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func applyTheme(theme: Theme) {
        super.applyTheme(theme: theme)
        collectionView.backgroundColor = theme.contentBackgroundColor
        bannerView.applyTheme(backgroundColor: theme.contentBackgroundColor)
    }
}
