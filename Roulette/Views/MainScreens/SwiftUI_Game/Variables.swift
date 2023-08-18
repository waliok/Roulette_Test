import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

let numToText: [String] = Array(0...36).map { String($0) } + ["2to1", "2to1", "2to1", "1st 12", "2st 12", "3st 12", "1 - 18", "Even", "", "", "Odd", "19 - 36"]

struct ChipInfo : Hashable{
    let id = UUID()
    var index:Int, type: Chip, rotate: Bool, offsetX: CGFloat, offsetY: CGFloat
    init(index: Int, type: Chip, rotate: Bool){
        self.index = index
        self.type = type
        self.rotate = rotate
        self.offsetX = CGFloat.random(in: -4..<4)
        self.offsetY = CGFloat.random(in: -4..<4)
    }
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
        hasher.combine(type.value)
        hasher.combine(rotate)
        hasher.combine(offsetY)
        hasher.combine(offsetX)
    }
    static func == (lhs:ChipInfo, rhs:ChipInfo) -> Bool {
        return lhs.index == rhs.index && lhs.type.value == rhs.type.value && lhs.rotate == rhs.rotate && lhs.offsetX == rhs.offsetX && lhs.offsetY == rhs.offsetY
    }
}

enum Chip {
    
    case oneK, fiveK, tenK, fiftyK, hundredK
    var value : Int {
        switch self {
        case .oneK:
            return 1
        case .fiveK:
            return 5
        case .tenK:
            return 10
        case .fiftyK:
            return 50
        case .hundredK:
            return 100
        }
    }
    
    var imageName: String {
        switch self {
        case .oneK:
            return "oneK"
        case .fiveK:
            return "fiveK"
        case .tenK:
            return "tenK"
        case .fiftyK:
            return "fiftyK"
        case .hundredK:
            return "hundredK"
        }
    }
}

enum numColor {
    case red, black, green, yellow
    var UIColor : Color {
        switch self {
        case .red:
            return Color.red
        case .black:
            return Color.black
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        }
    }
}

let blocksBetNums: [[Int]] = Array(0...36).map { Array([$0]) } + [
    [1,4,7,10,13,16,19,22,25,28,31,34], // 1st 2to1
    [2,5,8,11,14,17,20,23,26,29,32,35], // 2nd 2to1
    [3,6,9,12,15,18,21,24,27,30,33,36], // 3rd 2to1
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12], //1st 12
    [13,14,15,16,17,18,19,20,21,22,23,24], //2st 12
    [25,26,27,28,29,30,31,32,33,34,35,36], //3st 12
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18], // 1 - 18
    [2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36], // Even
    [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36], // Red
    [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35], // Black
    [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35], // Odd
    [19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36] // 19 - 36
]
