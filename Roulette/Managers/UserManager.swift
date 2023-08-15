//
//  UserManager.swift
//  Roulette
//
//  Created by Waliok on 15/08/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let dateCreated: Date?
    let name: String?
    let credits: Int
    let winRate: Double?

    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.dateCreated = Date()
        self.name = auth.name ?? ""
        self.credits = 2000
        self.winRate = nil
    }
    
    init(
        userId: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        dateCreated: Date? = nil,
        name: String? = nil,
        credits: Int = 2000,
        winRate: Double? = nil
    ) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.dateCreated = dateCreated
        self.name = name
        self.credits = credits
        self.winRate = winRate
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case dateCreated = "date_created"
        case name = "name"
        case credits = "credits"
        case winRate = "win_rate"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.credits = try container.decodeIfPresent(Int.self, forKey: .credits)!
        self.winRate = try container.decodeIfPresent(Double.self, forKey: .winRate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.credits, forKey: .credits)
        try container.encodeIfPresent(self.winRate, forKey: .winRate)
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserCredits(userId: String, value: Int) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.credits.rawValue : value
        ]

        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserWinRate(userId: String, winRate: Double) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.winRate.rawValue : winRate
        ]

        try await userDocument(userId: userId).updateData(data)
    }
}
