//
//  UserInfo.swift
//  Roulette
//
//  Created by Waliok on 14/08/2023.
//

import UIKit
import SnapKit

class UserInfoView: UIView {
    
    var user: DBUser
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 15
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var userName: UILabel = {
        let label = PaddingLabel()
        label.text = user.name
        label.paddingLeft = 10
        label.paddingTop = 10
        label.paddingBottom = 10
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var userScore: UILabel = {
        let label = PaddingLabel()
        label.text = String(user.credits)
        label.paddingRight = 10
        label.font = .boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(user: DBUser) {
        self.user = user
        super.init(frame: .zero)
        
        self.addSubview(stack)
        self.stack.addArrangedSubview(userName)
        self.stack.addArrangedSubview(userScore)
        self.stack.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        self.backgroundColor = .systemGray6
        // border radius
        self.layer.cornerRadius = 8

        // border
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.5

        // drop shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct UserInfo_Preview: PreviewProvider {
    
    static var previews: some View {
        
        UserInfoView(user: DBUser(userId: "123", isAnonymous: false, email: "@", dateCreated: Date(), name: "Waliok", credits: 2000, winRate: 0.23))
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif
