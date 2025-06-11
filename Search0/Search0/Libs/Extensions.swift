//
//  Extensions.swift
//  Search0
//
//  Created by shbaek on 6/10/25.
//
import UIKit

extension UIView {
    func shadow() {
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowPath = nil
    }
}

extension UILabel {
    static func label(_ text: String, _ fontsize: CGFloat, _ isBold: Bool = false) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.font = isBold ? UIFont.boldSystemFont(ofSize: fontsize) : UIFont.systemFont(ofSize: fontsize)
        return lb
    }
}
