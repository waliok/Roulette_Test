//
//  RatingVC.swift
//  Roulette
//
//  Created by Waliok on 12/08/2023.
//

import UIKit
import SnapKit

class RatingVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .red
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct RatingVC_Preview: PreviewProvider {
    
    static var previews: some View {
        
        RatingVC()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif
