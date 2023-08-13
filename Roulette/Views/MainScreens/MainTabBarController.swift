//
//  MainTabBarController.swift
//  Roulette
//
//  Created by Waliok on 12/08/2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [generateVC(vc: GameVC(), title: "Game", icon: "gamecontroller.fill", nav: true),
                           generateVC(vc: RatingVC(), title: "Rating", icon: "star.fill"),
                           generateVC(vc: SettingsVC(), title: "Settings", icon: "gearshape.fill")]
        
        setTabBar()
    }
    
    private func generateVC(vc: UIViewController, title: String, icon: String, nav: Bool = false) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(systemName: icon)
        if nav {
            return UINavigationController(rootViewController: vc)
        }
        return vc
    }
    
    private func setTabBar() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundedLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: CGRect(x: positionOnX,
                                                    y: tabBar.bounds.minY - positionOnY,
                                                    width: width,
                                                    height: height),
                                cornerRadius: height / 2)
        
        roundedLayer.path = path.cgPath
        tabBar.layer.insertSublayer(roundedLayer, at: 0)
        tabBar.itemWidth = width / 3
        tabBar.itemPositioning = .centered
        
        roundedLayer.fillColor = UIColor.lightGray.cgColor
        tabBar.tintColor = .green
        tabBar.unselectedItemTintColor = .magenta
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MainTabBar_Preview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        MainTabBarController()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif
