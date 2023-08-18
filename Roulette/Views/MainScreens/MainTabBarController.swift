import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [generateVC(vc: UIHostingController(rootView: GameView()), title: "Game", icon: "gamecontroller.fill", nav: true),
                           generateVC(vc: UINavigationController(rootViewController: RatingVC()), title: "Rating", icon: "star.fill"),
                           generateVC(vc: UINavigationController(rootViewController: SettingsVC()), title: "Settings", icon: "gearshape.fill")]
        
        setUpTabBar()
    }
    
    private func generateVC(vc: UIViewController, title: String, icon: String, nav: Bool = false) -> UIViewController {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(systemName: icon)
        if nav {
            return UINavigationController(rootViewController: vc)
        }
        return vc
    }
    
    private func setUpTabBar() {
        
        let roundedLayer = CAShapeLayer()
        tabBar.itemPositioning = .centered
        roundedLayer.fillColor = UIColor.lightGray.cgColor
        tabBar.tintColor = .systemYellow
        tabBar.unselectedItemTintColor = .systemGray
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct MainTabBar_Preview: PreviewProvider {
    
    static var previews: some View {
        MainTabBarController()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif
