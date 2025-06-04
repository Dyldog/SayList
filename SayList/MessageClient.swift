//
//  MessageClient.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

struct Message: Codable {
    let id: Int
    let songID: String
    let playlistID: String
    let sentAt: Date
    let content: String
    let user: User
}

class MessageClient {
    
    static let messagesUserDefaultsKey = "SAY_LIST_MESSAGES"
    private var messages: [Message]
    
    init() {
        messages = []
        retrieveMessagesFromStorage()
    }
    
    func retrieveMessagesFromStorage() {
        guard let messageData = UserDefaults.standard.data(forKey: MessageClient.messagesUserDefaultsKey), let messages = try? JSONDecoder().decode([Message].self, from: messageData) else { return }
        self.messages = messages
    }
    
    func saveMessagesToStorage() {
        guard let messageData = try? JSONEncoder().encode(messages) else { return }
        UserDefaults.standard.set(messageData, forKey: MessageClient.messagesUserDefaultsKey)
    }
    
    func getMessages(for songID: String, in playlistID: String, completion: ([Message]) -> Void) {
        completion(messages.filter { $0.songID == songID && $0.playlistID == playlistID })
    }
    
    func sendMessage(_ message: Message, completion: (Error?) -> Void) {
        messages.append(message)
        saveMessagesToStorage()
        completion(nil)
    }
}
