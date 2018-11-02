import UIKit

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.backgroundColor = .white
        window!.makeKeyAndVisible()
        let navigation = UINavigationController(rootViewController:UIViewController())
        navigation.navigationBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            navigation.navigationBar.prefersLargeTitles = true
            navigation.navigationItem.largeTitleDisplayMode = .always
        }
        window!.rootViewController = navigation
        return true
    }
}
