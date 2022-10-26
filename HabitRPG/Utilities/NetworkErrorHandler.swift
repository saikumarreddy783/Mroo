//
//  NetworkErrorHandler.swift
//  Habitica
//
//  Created by Phillip Thelen on 07.03.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import Habitica_API_Client

public struct DefaultServerUnavailableErrorMessage: ErrorMessage {
    public let message: String = "The server is unavailable! Try again in a bit. If this keeps happening, please let us know!"
    public let forCode: Int = 503
}

public struct DefaultServerIssueErrorMessage: ErrorMessage {
    public let message: String = "Looks like we're having a problem. Please let us know about it!"
    public let forCode: Int = 500
}

public struct DefaultOfflineErrorMessage: ErrorMessage {
    public let message: String = "Looks like you're offline. Try reconnecting to the internet!"
    public let forCode: Int = -1009
}

class HabiticaNetworkErrorHandler: NetworkErrorHandler {
    public static let errorMessages: [ErrorMessage]? = [DefaultServerUnavailableErrorMessage(), DefaultServerIssueErrorMessage(), DefaultOfflineErrorMessage()]
    let disposable = ScopedDisposable(CompositeDisposable())
    
    private static let dismissingVCs = [
        ChallengeDetailsTableViewController.self,
        SplitSocialViewController.self,
        PartyViewController.self,
        QuestDetailViewController.self,
        UserProfileViewController.self,
        GiftGemsViewController.self,
        GiftSubscriptionViewController.self
    ]
    
    public static func handle(error: NSError, messages: [String]) {
        if let errorMessage = errorMessageForCode(code: error.code) {
            notify(message: errorMessage.message, code: error.code)
        } else if !messages.isEmpty {
            notify(message: messages.joined(separator: "\n"), code: error.code)
        } else {
            notify(message: error.localizedDescription, code: 0)
        }
    }
    
    static func errorMessageForCode(code: Int) -> ErrorMessage? {
        if let messages = errorMessages {
            for errorMessage in messages where code == errorMessage.forCode {
                return errorMessage
            }
        }
        return nil
    }
    
    public static func notify(message: String, code: Int) {
        if code == 400 {
            let alertController = HabiticaAlertController(title: message)
            alertController.addCloseAction()
            alertController.show()
        } else {
            var duration: Double?
            if message.count > 200 {
                duration = 4.0
            }
            let toastView = ToastView(title: message, background: .red, duration: duration)
            ToastManager.show(toast: toastView)
        }
        
        if code == 404 {
            if let visibleViewController = UIApplication.topViewController(), dismissingVCs.contains(where: { type(of: visibleViewController) == $0 }) {
                visibleViewController.navigationController?.popViewController(animated: true)
            }
        }
    }
}
