//
//  ChatModel.swift
//  Chat Screen
//
//  Created by Meet Budheliya on 11/03/24.
//

import Foundation

// MARK: - ChatModel

struct Chat: Codable {
    let body, senderID, receiverID, time: String
    let bodyType, image: String

    enum CodingKeys: String, CodingKey {
        case body
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case time
        case bodyType = "body_type"
        case image
    }
}

typealias ChatModel = [Chat]
