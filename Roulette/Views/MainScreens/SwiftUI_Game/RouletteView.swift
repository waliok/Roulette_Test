import SwiftUI

enum rouletteColor: String {
    case red = "RED"
    case black = "BLACK"
    case green = "ZERO"
    case empty
}

struct Sector: Equatable {
    let number: Int
    let color: rouletteColor
}

struct RouletteView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var data: UserDataModel
    @State private var isAnimating = false
    @State private var spinDegrees = 0.0
    @State private var rand = 0.0
    @State private var newAngle = 0.0
    let halfSector = 360.0 / 37.0 / 2.0
    let sectors: [Sector] = [Sector(number: 32, color: .red),
                             Sector(number: 15, color: .black),
                             Sector(number: 19, color: .red),
                             Sector(number: 4, color: .black),
                             Sector(number: 21, color: .red),
                             Sector(number: 2, color: .black),
                             Sector(number: 25, color: .red),
                             Sector(number: 17, color: .black),
                             Sector(number: 34, color: .red),
                             Sector(number: 6, color: .black),
                             Sector(number: 27, color: .red),
                             Sector(number: 13, color: .black),
                             Sector(number: 36, color: .red),
                             Sector(number: 11, color: .black),
                             Sector(number: 30, color: .red),
                             Sector(number: 8, color: .black),
                             Sector(number: 23, color: .red),
                             Sector(number: 10, color: .black),
                             Sector(number: 5, color: .red),
                             Sector(number: 24, color: .black),
                             Sector(number: 16, color: .red),
                             Sector(number: 33, color: .black),
                             Sector(number: 1, color: .red),
                             Sector(number: 20, color: .black),
                             Sector(number: 14, color: .red),
                             Sector(number: 31, color: .black),
                             Sector(number: 9, color: .red),
                             Sector(number: 22, color: .black),
                             Sector(number: 18, color: .red),
                             Sector(number: 29, color: .black),
                             Sector(number: 7, color: .red),
                             Sector(number: 28, color: .black),
                             Sector(number: 12, color: .red),
                             Sector(number: 35, color: .black),
                             Sector(number: 3, color: .red),
                             Sector(number: 26, color: .black),
                             Sector(number: 0, color: .green)]
    var spinAnimation: Animation {
        Animation.easeOut(duration: 3.0)
            .repeatCount(1, autoreverses: false)
    }
    
    //MARK: - BODY
    
    var body: some View {
        
        ZStack {
            
            Image("Roulette")
                .resizable()
                .scaledToFill()
                .frame(width: 500, height: 900)
            
            VStack {
                
                Text(self.isAnimating ? "Spining\n..." : sectorFromAngle(angle : newAngle))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Image("Arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Image("roulette1")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: spinDegrees))
                    .frame(width: 245, height: 245, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .animation(spinAnimation)
                Button("SPIN") {
                    isAnimating = true
                    rand = Double.random(in: 1...360)
                    spinDegrees += 720.0 + rand
                    newAngle = getAngle(angle: spinDegrees)
                    var originColor: numColor = .yellow
                    var num: Int
                    num = getNumFromAngle(angle: newAngle)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
                        isAnimating = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.9) {
                        data.lastBet = data.bet
                        data.lastChipsInfo = data.chipsInfo
                        data.spinValue = num
                        dismiss()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                        originColor = data.numArray[data.spinValue]
                        data.numArray[data.spinValue] = .yellow
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
                        data.numArray[data.spinValue] = originColor
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                        data.numArray[data.spinValue] = .yellow
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                        data.numArray[data.spinValue] = originColor
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.9) {
                        data.totalCredits -= data.bet
                        for chip in data.chipsInfo {
                            if blocksBetNums[chip.index].contains(data.spinValue) {
                                data.totalCredits += chip.type.value*(36/blocksBetNums[chip.index].count)
                            }
                        }
                        data.chipsInfo = []
                        data.bet = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.5) {
                        if data.totalCredits <= 0 {
                            data.totalCredits = 100
                        }
                    }
                }
                .padding(40)
                .foregroundColor(.white)
                .disabled(isAnimating == true)
            }
        }
    }
}

extension RouletteView {
    
    //MARK: - Methods
    
    func getAngle(angle: Double) -> Double {
        let deg = 360 - angle.truncatingRemainder(dividingBy: 360)
        return deg
    }
    
    func sectorFromAngle(angle: Double) -> String {
        var i = 0
        var sector: Sector = Sector(number: -1, color: .empty)
        
        while sector == Sector(number: -1, color: .empty) && i < sectors.count {
            let start: Double = halfSector * Double((i*2 + 1)) - halfSector
            let end: Double = halfSector * Double((i*2 + 3))
            
            if(angle >= start && angle < end) {
                sector = sectors[i]
            }
            i+=1
        }
        return "Sector\n\(sector.number) \(sector.color.rawValue)"
    }
    
    func getNumFromAngle(angle: Double) -> Int {
        var i = 0
        var sector: Sector = Sector(number: -1, color: .empty)
        
        while sector == Sector(number: -1, color: .empty) && i < sectors.count {
            let start: Double = halfSector * Double((i*2 + 1)) - halfSector
            let end: Double = halfSector * Double((i*2 + 3))
            
            if(angle >= start && angle < end) {
                sector = sectors[i]
            }
            i+=1
        }
        return sector.number
    }
}
