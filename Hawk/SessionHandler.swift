//
//  HomeController.swift
//  Hawk
//
//  Created by Philip Mogull on 15/06/2019.
//  Copyright © 2019 Philip Mogull. All rights reserved.
//

import Foundation
import WatchConnectivity
import os.log
import FirebaseUI
import FirebaseFirestore




protocol SessionHandlerDelegate {
    func updateLabel (_ message: String)
    
    
}

class SessionHandler : NSObject, WCSessionDelegate {
    
    var counter = 0
    
    // 1: Singleton
    static let shared = SessionHandler()
    
    var sessionHandlerDelegate: SessionHandlerDelegate?
    
    
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
    
    // 4: Required protocols
    
    // a
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    // b
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session)")
    }
    
    // c
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
        
        counter = counter + 1
        
        let newMessage = message["request"]
        sessionHandlerDelegate?.updateLabel(newMessage as! String)
        
        
 //     When message is received by phone, send information/ store information to Firestore
        let docData: [String: Any] = [
            "Stroke Type": newMessage!,
            "booleanExample": true,
            "numberExample": 3.14159265,
            "date": Timestamp(date: Date()),
            "arrayExample": [5, true, "hello"],
        ]
        
        
        let auth = FUIAuth.defaultAuthUI()!
                
                   if auth.auth?.currentUser != nil {
                    let uid = auth.auth!.currentUser?.uid
                    os_log("test test test")
                    let  db=Firestore.firestore()
                    db.collection(uid!).addDocument(data: docData) { (error) in
                        
                        if error != nil{
                            // Show error message
                            print("Error saving user data to database")
                            }
                        }
                 
                }
                   else {
                   print("No user signed in")
                }
        
        //os_log("test test test")
        
        if message["request"] as? String == "version" {
            replyHandler(["version" : "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "No version")"])
        }
    }
}
