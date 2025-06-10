//
//  Extensions.swift
//  Search0
//
//  Created by shbaek on 6/10/25.
//
import UIKit

extension UILabel {
    static func label(_ text: String, _ fontsize: CGFloat, _ isBold: Bool = false) -> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.font = isBold ? UIFont.boldSystemFont(ofSize: fontsize) : UIFont.systemFont(ofSize: fontsize)
        return lb
    }
}
