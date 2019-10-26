//
//  PlaySessionHandler.swift
//  Hawk
//
//  Created by Keshwyn Annauth on 20/09/2019.
//  Copyright © 2019 Keshwyn Annauth. All rights reserved.
//

import Foundation
import WatchConnectivity
import os.log

protocol PlaySessionHandlerDelegate {
    func updateCount ()
    func analyseStroke(_ fileURL: URL)
}

class PlaySessionHandler : NSObject, WCSessionDelegate {
    var counter = 0
    
    // 1: Singleton
    static let shared = PlaySessionHandler()
    var sessionHandlerDelegate: PlaySessionHandlerDelegate?
    
    
    // 2: Property to manage session
    private var session = WCSession.default
    
    override init() {
        super.init()
        // 3: Start and avtivate session if it's supported
        if isSuported() {
            session.delegate = self
            session.activate()
        }
        print("isPaired?: \(session.isPaired), isWatchAppInstalled?: \(session.isWatchAppInstalled)")
    }
    
    func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate: \(session)")
        // Reactivate session
        /**
         * This is to re-activate the session on the phone when the user has switched from one
         * paired watch to second paired one. Calling it like this assumes that you have no other
         * threads/part of your code that needs to be given time before the switch occurs.
         */
        self.session.activate()
    }
    
    /// Observer to receive messages from watch and we be able to response it
    ///
    /// - Parameters:
    ///   - session: session
    ///   - message: message received
    ///   - replyHandler: response handler
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["request"] as? String == "version" {
            replyHandler(["Mode" : "Play"])
        }
    }
    
    /// Called when file is received - this is used to transfer data even when screen is turned off
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        self.sessionHandlerDelegate?.updateCount()
        self.sessionHandlerDelegate?.analyseStroke(file.fileURL)
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        DispatchQueue.main.async {
            self.sessionHandlerDelegate?.updateCount()
        }
    }
    
}

