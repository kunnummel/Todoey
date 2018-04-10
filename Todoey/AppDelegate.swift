//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mac Dev on 05/04/2018.
//  Copyright © 2018 Mac Dev. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL)

        do{
            
         //   _ = try Realm()
        }catch{
            print("error \(error)")
        }
        
        return true
    }
   
}

