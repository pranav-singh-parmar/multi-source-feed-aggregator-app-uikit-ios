//
//  UIViewController.swift
//  MultiSourceFeedAggregatorApp
//
//  Created by Pranav Singh on 28/09/25.
//

import UIKit

fileprivate let toastViewTag = 12345

extension UIViewController {
    func showToast(withMessage message: String) {
        guard let window = UIApplication.shared.getKeyWindow else { return }
        
        if let old = window.viewWithTag(toastViewTag) {
            old.removeFromSuperview()
        }
        
        let toast = PaddedLabel()
        toast.text = message
        toast.font = .systemFont(ofSize: 16)
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toast.textAlignment = .center
        toast.numberOfLines = 0
        toast.layer.cornerRadius = 8
        toast.layer.masksToBounds = true
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.alpha = 0
        toast.tag = toastViewTag
        
        window.addSubview(toast)
        
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            toast.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            toast.heightAnchor.constraint(greaterThanOrEqualToConstant: 35)
        ])
        
        UIView.animate(withDuration: 0.3) {
            toast.alpha = 1
        }
        
        /// Auto hide after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3, animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
}
