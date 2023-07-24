//
//  UIToolBar.swift
//  Damirka.Space
//
//  Created by Dam1rka on 22.07.2023.
//

import SwiftUI

extension UIToolbar {
    
    // Clear shadows in tabview and toolbar
    
    static func changeAppearance(clear: Bool) {
        let appearance = UIToolbarAppearance()
        let tabAppearance = UITabBarAppearance()
        
        if clear {
            appearance.configureWithOpaqueBackground()
            tabAppearance.configureWithOpaqueBackground()
        } else {
            appearance.configureWithDefaultBackground()
            tabAppearance.configureWithDefaultBackground()
        }

        // customize appearance for your needs here
        appearance.shadowColor = .clear
        tabAppearance.shadowColor = .clear
        appearance.backgroundColor = .clear
        tabAppearance.backgroundColor = .clear
        //appearance.backgroundImage = UIImage(named: "imageName")
        
        UIToolbar.appearance().standardAppearance = appearance
        UITabBar.appearance().standardAppearance = tabAppearance
    }
}
