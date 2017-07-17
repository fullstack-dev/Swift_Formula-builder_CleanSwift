//
//  AppDelegate.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/3/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // configure app's appearance
        FBAppearance.configureAppearance()
        
        return true
    }
    

}

