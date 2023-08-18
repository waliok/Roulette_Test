import SwiftUI
import FirebaseAuth

struct GameView: View {
    
    @StateObject var data = UserDataModel()
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            BoardView()
                .offset(x:50, y: -30)
            ChipsView()
                .offset(x:-145, y:50)
            ButtonView()
                .offset(x:40, y:300)
        }
        .padding()
        .environmentObject(data)
        .onAppear() {
            Task {
                data.user = try! await UserManager.shared.loadCurrentUser()
            }
        }
        .onDisappear {
            Task {
                try! await UserManager.shared.updateUserCredits(userId: Auth.auth().currentUser!.uid, value: data.totalCredits)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
