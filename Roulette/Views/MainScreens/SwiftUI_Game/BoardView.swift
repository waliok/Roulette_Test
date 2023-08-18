import SwiftUI

let blockWidth: CGFloat = 50, blockHeight: CGFloat = 40

struct Block: View {
    
    @EnvironmentObject var data: UserDataModel
    var rotate:Bool, index: Int, color: Color?, width: CGFloat, height: CGFloat
    
    init(rotate:Bool, index:Int, width: CGFloat, height: CGFloat, color: Color?=nil) {
        self.rotate = rotate
        self.index = index
        self.color = color
        self.width = width
        self.height = height
    }
    
    var body: some View {
        
        ZStack {
            
            Text("\(numToText[index])")
                .font(.system(size: 20, design: .rounded))
                .foregroundColor(.white)
                .if(rotate==true){ view in
                    view.frame(width: blockHeight*4)
                        .rotationEffect(.degrees(90))
                }
                .frame(width: width, height: height)
                .if((index <= 36 && index > 0) || color != nil){ view in
                    view.background((color != nil) ? color : data.numArray[index].UIColor)
                }
                .border(.white, width:2)
                .contentShape(Rectangle())
            
            ZStack {
                
                ForEach(data.chipsInfo.filter({$0.index == index}), id: \.self) { info in
                    BoardChip(type: info.type, rotate: rotate, x: info.offsetX, y: info.offsetY)
                }
            }
        }
        .onTapGesture {
            if data.bet <= data.totalCredits - data.selectedChip.value {
                data.chipsInfo.append(ChipInfo(index: index, type: data.selectedChip, rotate: rotate))
                data.bet += data.selectedChip.value
            }
        }
    }
}

struct BoardView: View {
    
    let columnArray: [[Int]] = [
        Array(stride(from: 1, through: 34, by: 3)),
        Array(stride(from: 2, through: 35, by: 3)),
        Array(stride(from: 3, through: 36, by: 3))
    ]
    
    var body: some View {
        
        VStack(spacing:-2) {
            
            HStack(spacing:-2){
                Text("")
                    .frame(width: blockWidth*6/5-2, height: blockHeight)
                Block(rotate: false, index: 0, width: blockWidth*3-4, height: blockHeight)
            }
            
            ZStack {
                
                HStack(alignment:.top,spacing:-2) {
                    
                    VStack(spacing:-2) {
                        Block(rotate: true, index: 43, width: blockWidth*3/5, height: blockHeight*2-2)
                        Block(rotate: true, index: 44, width: blockWidth*3/5, height: blockHeight*2-2)
                        Block(rotate: true, index: 45, width: blockWidth*3/5, height: blockHeight*2-2, color: Color.red)
                        Block(rotate: true, index: 46, width: blockWidth*3/5, height: blockHeight*2-2, color: Color.black)
                        Block(rotate: true, index: 47, width: blockWidth*3/5, height: blockHeight*2-2)
                        Block(rotate: true, index: 48, width: blockWidth*3/5, height: blockHeight*2-2)
                    }
                    VStack(spacing:-2) {
                        Block(rotate: true, index: 40, width: blockWidth*3/5, height: blockHeight*4-6)
                        Block(rotate: true, index: 41, width: blockWidth*3/5, height: blockHeight*4-6)
                        Block(rotate: true, index: 42, width: blockWidth*3/5, height: blockHeight*4-6)
                    }
                    ForEach(Array(columnArray.enumerated()), id: \.element){ index, column in
                        
                        VStack(spacing: -2) {
                            ForEach(column, id: \.self){ num in
                                Block(rotate: false, index: num, width: blockWidth, height: blockHeight)
                            }
                            Block(rotate: false, index: 37+index, width: blockWidth, height: blockHeight)
                        }
                    }
                }
            }
        }
    }
}

