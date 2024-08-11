import SwiftUI
import Foundation

struct Design {
    //designs the tab navigation
    static func designTabNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .white
        
        // Customize title color
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.navyBlue,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        // Apply the appearance to the navation bar
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.shadowColor = UIColor.navyBlue
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.navyBlue.withAlphaComponent(0.4)
        tabBarAppearance.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    //changes the color of the current image indicator to navyBlue
    static func setUpAppearanceForUploadPost() {
      UIPageControl.appearance().currentPageIndicatorTintColor = .navyBlue
      UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    //hides the navigation background when makes logout or delete account from signup and reset password
    static func hideNavigationBackground() {
        let appearence = UINavigationBarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = UIColor.clear
        
        UINavigationBar.appearance().standardAppearance = appearence
        UINavigationBar.appearance().compactAppearance = appearence
        UINavigationBar.appearance().scrollEdgeAppearance = appearence
    }
}
