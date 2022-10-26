//
//  ReadyToConnectViewController.swift
//  Habitica
//
//  Created by Surya Pratap Singh on 23/09/22.
//  Copyright © 2022 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models
import ReactiveSwift

class ReadyToConnectViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var lblTitle: UIView!
    @IBOutlet weak var lblSubTitle: UIView!
    @IBOutlet weak var connectImageView: UIImageView!
    
    var userRepository = UserRepository()
    
    private let configRepository = ConfigRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        backButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        backButton.tintColor = UIColor("#262626")
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc
    func nextButtonPressed() {
        performSegue(withIdentifier: "DeviceSetupSegue", sender: self)
    }
    @objc
    func skipButtonPressed() {
        showMainView()
    }
    @objc
    func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func showMainView() {
        performSegue(withIdentifier: "MainSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeviceSetupSegue" {
            
        }
    }
}
