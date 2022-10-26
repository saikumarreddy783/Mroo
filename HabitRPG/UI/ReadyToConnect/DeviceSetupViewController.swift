//
//  DeviceSetupViewController.swift
//  Habitica
//
//  Created by Surya Pratap Singh on 23/09/22.
//  Copyright © 2022 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models
import ReactiveSwift

class DeviceSetupViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTitle: UIView!
    @IBOutlet weak var lblSubTitle: UIView!
    
    @IBOutlet weak var lblDeviceName: UIView!
    @IBOutlet weak var lblDeviceConnectConfirmation: UIView!
    
    @IBOutlet weak var connectImageView: UIImageView!
    @IBOutlet weak var lblConnectSno: UILabel!
    
    @IBOutlet weak var viewSuccessFull: UIView!
    @IBOutlet weak var lblConnectedDeviceName: UILabel!
    @IBOutlet weak var lblConnectedSuccessfully: UILabel!
    
    var userRepository = UserRepository()
    
    private let configRepository = ConfigRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        backButton.setImage(UIImage(named: "left-arrow"), for: .normal)
        backButton.tintColor = UIColor("#262626")
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+6.0, execute: {
            self.deviceFoundUI()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupUI() {
        backButton.isHidden = false
        nextButton.isHidden = true
        skipButton.isHidden = true
        activityIndicator.isHidden = false
        
        lblTitle.isHidden = false
        lblSubTitle.isHidden = false
        lblDeviceName.isHidden = true
        lblDeviceConnectConfirmation.isHidden = true
        
        connectImageView.isHidden = false
        lblConnectSno.isHidden = true
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        viewSuccessFull.isHidden = true
    }
    
    func deviceFoundUI() {
        backButton.isHidden = true
        nextButton.isHidden = false
        skipButton.isHidden = false
        activityIndicator.isHidden = true
        
        lblTitle.isHidden = true
        lblSubTitle.isHidden = true
        lblDeviceName.isHidden = false
        lblDeviceConnectConfirmation.isHidden = false
        
        connectImageView.isHidden = true
        lblConnectSno.isHidden = false
        
        activityIndicator.stopAnimating()
    }
    
    @objc
    func nextButtonPressed() {
        viewSuccessFull.isHidden = false
        // lblConnectedDeviceName.text = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
            self.showMainView()
        })
    }
    @objc
    func skipButtonPressed() {
        
    }
    @objc
    func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func showMainView() {
        performSegue(withIdentifier: "MainSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
