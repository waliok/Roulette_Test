import SwiftUI

class UserDataModel: ObservableObject {
    
    @Published var user: DBUser? {
        didSet {
            self.name = user?.name ?? ""
            self.totalCredits = user?.credits ?? 0
        }
    }
    @Published var name: String = "No name"
    @Published var selectedChip: Chip = Chip.oneK
    @Published var totalCredits: Int = 0
    @Published var bet: Int = 0
    @Published var lastBet: Int = 0
    @Published var chipsInfo: [ChipInfo] = []
    @Published var lastChipsInfo: [ChipInfo] = []
    @Published var isSpinning = false
    @Published var spinValue:Int = 0
    @Published var numArray: [numColor] = [.green, .red, .black, .red, .black, .red,.black, .red,.black, .red,.black, .black, .red,.black,.red,.black,.red,.black,.red,.red, .black, .red,.black, .red,.black, .red,.black, .red,.black, .black,.red, .black,.red, .black,.red, .black, .red]
}
