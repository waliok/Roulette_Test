//
//  GameVC.swift
//  Roulette
//
//  Created by Waliok on 12/08/2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import Combine

class GameVC: UIViewController {
    
    @Published private(set) var user: DBUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        
        Task {
            try! await self.loadCurrentUser()
            
           setUpUserInfoView()
        }
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct GameVC_Preview: PreviewProvider {
    
    static var previews: some View {
        
        GameVC()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif

extension GameVC {
    
    func loadCurrentUser() async throws {
        
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let user = try? await UserManager.shared.getUser(userId: authDataResult.uid)
        if user != nil {
            self.user = user
        } else {
            try await UserManager.shared.createNewUser(user: DBUser(auth: authDataResult))
            self.user = try? await UserManager.shared.getUser(userId: authDataResult.uid)
        }
    }
    
    func setUpUserInfoView() {
        var userInfoView = UIView()
        guard let user = self.user else { return }
        userInfoView = UserInfoView(user: user)
        self.view.addSubview(userInfoView)
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(40)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-40)
        }
    }
}
