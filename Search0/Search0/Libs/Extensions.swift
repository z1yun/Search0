//
//  Extensions.swift
//  Search0
//
//  Created by shbaek on 6/10/25.
//
import UIKit


extension UIViewController {
    func showAlert(msg: String) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}

extension Int {
    func decimalString() -> String {
        let numberFmt = NumberFormatter()
        numberFmt.numberStyle = .decimal
        return numberFmt.string(from: NSNumber(value: self)) ?? ""
    }
}

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
