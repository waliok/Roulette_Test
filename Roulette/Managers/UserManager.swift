import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

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
        self.name = auth.name ?? "No name"
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
    
    func loadCurrentUser() async throws -> DBUser {
        
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        var user = try? await UserManager.shared.getUser(userId: authDataResult.uid)
        if let DBuser = user {
            return DBuser
        } else {
            try await UserManager.shared.createNewUser(user: DBUser(auth: authDataResult))
            user = try? await UserManager.shared.getUser(userId: authDataResult.uid)
            return user!
        }
    }
    
    func getAllUsers() async throws -> [DBUser] {
        try await userCollection.getDocuments(as: DBUser.self)
    }
}

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let products: [T] = documents.compactMap({ try? $0.data(as: T.self) })
            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
}
