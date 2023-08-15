//
//  AuthenticationManager.swift
//  Roulette
//
//  Created by Waliok on 15/08/2023.
//

import Foundation
import Firebase
import FirebaseCore

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let name: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.name = user.displayName
        self.isAnonymous = user.isAnonymous
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
}
