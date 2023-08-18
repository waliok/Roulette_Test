import SwiftUI

struct BackgroundView: View {
    
    @EnvironmentObject var data: UserDataModel
    
    var body: some View {
        
        ZStack {
            
            Image("Roulette")
                .resizable()
                .scaledToFill()
                .frame(width: 500, height: 900)
            Image("table")
                .resizable()
                .frame(width: 350, height: 850)
                .offset(x:30, y:-95)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black)
                    .opacity(0.5)
                    .frame(width: 200, height: 125)
                Capsule()
                    .fill(.black)
                    .frame(width: 170, height: 40)
                    .offset(y:-30)
                Capsule()
                    .fill(.white)
                    .frame(width: 170, height: 40)
                    .offset(y:30)
                Text("B")
                    .foregroundColor(.white)
                    .frame(width: 150)
                    .font(.system(size: 34))
                    .background(.green)
                    .clipShape(Circle())
                    .offset(x:-70, y:30)
                Image(systemName:"dollarsign.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .offset(x:-70,y:-30)
                Text("\(data.totalCredits) K")
                    .foregroundColor(.yellow)
                    .font(.system(size: 30, design: .rounded))
                    .bold()
                    .frame(width: 300, alignment: .trailing)
                    .offset(x:-80,y:-30)
                Text("\(data.bet) K")
                    .foregroundColor(.red)
                    .font(.system(size: 30, design: .rounded))
                    .bold()
                    .frame(width: 300, alignment: .trailing)
                    .offset(x:-80,y:30)
                if data.totalCredits <= 0 {
                    
                    VStack {
                        
                        Text("Game Over!")
                            .foregroundColor(.white)
                            .padding()
                        Button {
                            data.totalCredits = 100
                        } label: {
                            Text("Try again")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .font(.system(size: 30, design: .rounded))
                    .bold()
                    .offset(x:-10,y:150)
                }
            }
            .scaleEffect(x: 0.5, y: 0.5, anchor: .topLeading)
            .offset(x:-65,y:-235)
            
            Text(data.name)
                .foregroundColor(.yellow)
                .font(.largeTitle.bold())
                .offset(x: 0, y: -350)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.black)
                        .opacity(0.5)
                        .frame(width: 385, height: 60)
                        .offset(x: 0, y: -347)
                }
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
            .environmentObject(UserDataModel())
    }
}
