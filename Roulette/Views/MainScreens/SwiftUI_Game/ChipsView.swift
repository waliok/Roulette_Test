import SwiftUI

struct ChipView: View {
    
    @EnvironmentObject var data: UserDataModel
    var type: Chip
    init(type: Chip) {
        self.type = type
    }
    
    var body: some View {
        
        ZStack {
            
            Image("\(type.imageName)")
                .resizable()
                .frame(width: 70 , height: 70 )
                .shadow(radius: 3.0, x: 6, y: 6)
                .if(data.selectedChip == type) { view in
                    view.border(.red, width: 2)
                        .scaleEffect(1.2)
                }
                .onTapGesture {
                    data.selectedChip = type
                }
            Text("\(type.value)K")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
}

struct BoardChip: View {
    
    var type: Chip, x: CGFloat=0, y: CGFloat=0, rotate: Bool
    init(type: Chip, rotate: Bool, x: CGFloat, y: CGFloat) {
        self.type = type
        self.rotate = rotate
        self.x = x
        self.y = y
    }
    
    var body: some View {
        
        Image("\(type.imageName)")
            .resizable()
            .frame(width: 30, height: 30)
            .shadow(radius: 3.0, x: 6, y: 6)
            .offset(x:x, y:y)
    }
}

struct ChipsView: View {
    
    var body: some View {
        
        VStack {
            ChipView(type: Chip.oneK)
            ChipView(type: Chip.fiveK)
            ChipView(type: Chip.tenK)
            ChipView(type: Chip.fiftyK)
            ChipView(type: Chip.hundredK)
        }
    }
}

