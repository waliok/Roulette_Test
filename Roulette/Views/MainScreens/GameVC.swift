//
//  GameVC.swift
//  Roulette
//
//  Created by Waliok on 12/08/2023.
//

import UIKit

class GameVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .cyan
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
