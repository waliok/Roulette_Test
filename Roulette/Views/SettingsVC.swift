//
//  SettingsVC.swift
//  Roulette
//
//  Created by Waliok on 12/08/2023.
//

import UIKit
import SnapKit

class SettingsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .green
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct SettingsVC_Preview: PreviewProvider {
    
    static var previews: some View {
        
        SettingsVC()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif
