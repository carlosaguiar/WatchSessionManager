//
//  WatchSessionManager.swift
//  WatchSessionManager
//
//  Created by Carlos Aguiar on 24/01/2018.
//  Copyright © 2018 Bliss Applications. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

typealias MessageClosure = (Any)->()
typealias MessageReplyHandler = (([String : Any]) -> Void)
typealias MessageErrorHandler = ((Error) -> Void)

class WatchSessionManager: NSObject {

  private var session: WCSession = WCSession.default

  private let messageListeners = [String: [MessageClosure]]()
  private let contextListeners = [String: [MessageClosure]]()

  private var lastContext = [String: Any]()

  private override init() {
    super.init()

    self.session.delegate = self
  }

  public func activateSessionListening() {
    self.session.activate()

    let applicationContext = self.session.applicationContext
    lastContext.addEntriesFromDictionary(dictionary: applicationContext)

    let receivedContext = self.session.receivedApplicationContext
    lastContext.addEntriesFromDictionary(dictionary: receivedContext)
  }

  fileprivate func notifyListenersForMessage(withIdentifier identifier: String, message: Any) {

    if let closures = messageListeners[identifier] {
      DispatchQueue.main.async {
        for closure in closures {
          closure(message)
        }
      }
    }
  }

  public func writeMessage(_ message: Any, forIdentifier identifier: String, replayHandler: MessageReplyHandler?, errorHandler: MessageErrorHandler?) -> Bool {
    if session.isReachable {
      self.session.sendMessage([identifier : message], replyHandler: replayHandler, errorHandler: errorHandler)

      return true
    }

    return false
  }

  public func writeContextMessage(_ message: Any, forIdentifier identifier: String) throws -> Bool{
    guard WCSession.isSupported() == true else { return false }

    var currentContext = lastContext
    currentContext[identifier] = message
    lastContext = currentContext

    do {
      try self.session.updateApplicationContext(currentContext)
      return true
    } catch (let error) {
      throw error
    }
  }

  public func contextMessageForIdentifier(_ identifier: String)  -> Any?{
    return lastContext[identifier]
  }

  public func deleteContextForIdentifier(_ identifier: String) throws {
    lastContext.removeValue(forKey: identifier)

    let currentContext = lastContext

    do {
      try self.session.updateApplicationContext(currentContext)
    } catch (let error) {
      throw error
    }
  }

  public func deleteContext() throws {
    lastContext.removeAll()

    let currentContext = lastContext

    do {
      try self.session.updateApplicationContext(currentContext)
    } catch (let error) {
      throw error
    }
  }
}

extension WatchSessionManager: WCSessionDelegate {
  #if os(iOS)
  func sessionDidBecomeInactive(_ session: WCSession) {

  }

  func sessionDidDeactivate(_ session: WCSession) {

  }
  #endif


  /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
  internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

  }

  /** ------------------------- Interactive Messaging ------------------------- */

  /** Called when the reachable state of the counterpart app changes. The receiver should check the reachable property on receiving this delegate callback. */
  internal func  sessionReachabilityDidChange(_ session: WCSession) {

  }


  /** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
  internal func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    for (identifier, value) in message {
      self.notifyListenersForMessage(withIdentifier: identifier, message: value)
    }
  }


  /** Called on the delegate of the receiver when the sender sends a message that expects a reply. Will be called on startup if the incoming message caused the receiver to launch. */
  internal func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {

  }


  /** Called on the delegate of the receiver. Will be called on startup if the incoming message data caused the receiver to launch. */
  internal func session(_ session: WCSession, didReceiveMessageData messageData: Data) {

  }


  /** Called on the delegate of the receiver when the sender sends message data that expects a reply. Will be called on startup if the incoming message data caused the receiver to launch. */
  internal func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Swift.Void) {

  }


  /** -------------------------- Background Transfers ------------------------- */

  /** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
  internal func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    for (identifier, data) in applicationContext {
      self.notifyListenersForMessage(withIdentifier: identifier, message: data)
    }
  }


  /** Called on the sending side after the user info transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the user info finished. */
  internal func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {

  }


  /** Called on the delegate of the receiver. Will be called on startup if the user info finished transferring when the receiver was not running. */
  internal func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {

  }


  /** Called on the sending side after the file transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the transfer finished. */
  internal func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {

  }


  /** Called on the delegate of the receiver. Will be called on startup if the file finished transferring when the receiver was not running. The incoming file will be located in the Documents/Inbox/ folder when being delivered. The receiver must take ownership of the file by moving it to another location. The system will remove any content that has not been moved when this delegate method returns. */
  internal func session(_ session: WCSession, didReceive file: WCSessionFile) {

  }

}
