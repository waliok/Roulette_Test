import UIKit
import SnapKit
import Firebase
import StoreKit

class SettingsVC: UIViewController {
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var rateAppButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Rate App"
        configuration.baseBackgroundColor = .systemYellow
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .medium
        configuration.buttonSize = .large
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(rateButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var shareAppButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Share App"
        configuration.baseBackgroundColor = .systemYellow
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .medium
        configuration.buttonSize = .large
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var logOutButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Log Out"
        configuration.baseBackgroundColor = .systemYellow
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .medium
        configuration.buttonSize = .large
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Delete Account"
        configuration.baseBackgroundColor = .systemYellow
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .medium
        configuration.buttonSize = .large
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - View_Did_Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let back = UIImageView(image: .init(named: "Roulette"))
        back.contentMode = UIView.ContentMode.scaleToFill
        self.view.addSubview(back)
        back.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.view.addSubview(buttonStack)
        buttonStack.addArrangedSubview(rateAppButton)
        buttonStack.addArrangedSubview(shareAppButton)
        buttonStack.addArrangedSubview(deleteAccountButton)
        buttonStack.addArrangedSubview(logOutButton)
        buttonStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}

private extension SettingsVC {
    
    @objc func rateButtonPressed() {
        if let scene = UIApplication
            .shared
            .connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    @objc func shareButtonPressed() {
        guard let image = UIImage(systemName: "bell"), let url = URL(string: "https://github.com/waliok/Roulette_Test") else { return }
        
        let shareSheetVC = UIActivityViewController(activityItems: [image, url],
                                                    applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
    @objc func deleteButtonPressed() {
        
        let user = Auth.auth().currentUser
        
        user?.delete() { error in
            if let error = error {
                print("Unable to delete user; \(error.localizedDescription)")
            } else {
            
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(UINavigationController(rootViewController: LoginViewController()))
            }
        }
    }
    
    @objc func logOutButtonPressed() {
        
        do {
            try Auth.auth().signOut()
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(UINavigationController(rootViewController: LoginViewController()))
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//MARK: - Preview

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
