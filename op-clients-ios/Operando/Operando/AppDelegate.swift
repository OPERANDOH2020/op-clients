//
//  AppDelegate.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import PPCloak
import PPApiHooksCore
import iOSNM

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {
        let window = UIWindow(frame: UIScreen.main.bounds)
        OPConfigObject.sharedInstance.applicationDidStartInWindow(window: window)
        self.window = window
        window.makeKeyAndVisible()
        
        
        OPMonitor.initializeMonitoring()
        
        print(Bundle(for: PPEvent.self))
        
        let address: String = "\(Bundle.main.privateFrameworksPath!)/PPApiHooksCore.framework/PPApiHooksCore"
        
        if let context = retrieveSymbolsFromFile(address){
            for i in 0 ..< context.pointee.numberOfSymbols {
                if let symbolInfoPtr = context.pointee.currentSymbols.advanced(by: Int(i)).pointee {
                    printSymbolInfo(symbolInfoPtr)
                }
                
            }
            
            releaseSymbolsContext(context)
        }
        
        return true
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return OPConfigObject.sharedInstance.open(url: url)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return OPConfigObject.sharedInstance.open(url: url)
    }
}

