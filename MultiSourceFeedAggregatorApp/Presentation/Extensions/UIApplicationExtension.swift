//
//  UIApplicationExtension.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import UIKit

//MARK: - UIApplication
extension UIApplication {
    var getKeyWindow: UIWindow? {
        if #available(iOS 15, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow
        } else {
            return UIApplication.shared.windows.first
        }
    }
}
