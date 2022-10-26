//
//  HallOfContributorsViewController.swift
//  Habitica
//
//  Created by Phillip Thelen on 11.08.20.
//  Copyright © 2020 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models

class HallOfContributorsViewController: BaseTableViewController {

    private let dataSource = HallOfContributorsDataSource()
    private var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topHeaderCoordinator?.hideHeader = true
        topHeaderCoordinator?.followScrollView = false
        navigationItem.title = L10n.Titles.hallOfContributors
        
        dataSource.tableView = tableView

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = dataSource.item(at: indexPath)
        let navController = StoryboardScene.Social.userProfileNavController.instantiate()
        let profileViewControler = navController.topViewController as? UserProfileViewController
        profileViewControler?.username = member?.username
        profileViewControler?.userID = member?.id
        profileViewControler?.needsDoneButton = true
        present(navController, animated: true, completion: nil)
    }
}
