//
//  Area_Master_ToolsApp.swift
//  Area Master Tools
//
//  Created by Алкександр Степанов on 17.11.2025.
//

import SwiftUI

@main
struct Area_Master_ToolsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

class AppDelegate: NSObject, URLSessionDelegate {
    @AppStorage("levelInfo") var level = false
    @AppStorage("valid") var validationIsOn = false
    static var orientationLock = UIInterfaceOrientationMask.all
    private var validationPerformed = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if OrientationManager.shared.isHorizontalLock {
            // Для игры - только вертикальная ориентация
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                AppDelegate().setOrientation(to: .portrait)
            }
            return .portrait
        } else {
            // Для сайта - все ориентации
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                AppDelegate.orientationLock = .allButUpsideDown
            }
            return .allButUpsideDown
        }
    }
}

extension AppDelegate: UIApplicationDelegate {
    
    func setOrientation(to orientation: UIInterfaceOrientation) {
        switch orientation {
        case .portrait:
            AppDelegate.orientationLock = .portrait
        case .landscapeRight:
            AppDelegate.orientationLock = .landscapeRight
        case .landscapeLeft:
            AppDelegate.orientationLock = .landscapeLeft
        case .portraitUpsideDown:
            AppDelegate.orientationLock = .portraitUpsideDown
        default:
            AppDelegate.orientationLock = .all
        }
        
        // Используем современный API для изменения ориентации
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            let geometryPreferences: UIWindowScene.GeometryPreferences
            switch orientation {
            case .portrait:
                geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
            case .landscapeRight:
                geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeRight)
            case .landscapeLeft:
                geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeLeft)
            case .portraitUpsideDown:
                geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portraitUpsideDown)
            default:
                geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .all)
            }
            
            windowScene.requestGeometryUpdate(geometryPreferences) { error in
                print("Geometry update error: \(error)")
            }
        } else {
            // Для старых версий iOS используем старый метод
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
    
}
