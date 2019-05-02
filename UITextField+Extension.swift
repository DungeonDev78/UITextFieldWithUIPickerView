//
//  UITextField+Extension.swift
//
//  Created with 💪 by Alessandro Manilii.
//  Copyright © 2019 Alessandro Manilii. All rights reserved.
//

import UIKit

extension UITextField {

    /// Configure the chosen UITextField in order to use a selectable UIPickerView. The picker has an input accessory view with a toolbar used to close the keyboard
    ///
    /// - Parameters:
    ///   - options: an array of String with the available options for the user
    ///   - parentViewController: the UIViewController chosen to show the picker, the one holding the UITextField
    ///   - doneButtonText: the text used in the "Done" button
    func configureWith(options: [String],
                       on parentViewController: UIViewController,
                       doneButtonText: String? = nil,
                       toolbarColor: UIColor = .lightGray,
                       toolbarButtonColor: UIColor = .black) {

        self.parentViewController = parentViewController
        self.options = options
        self.pickerView = UIPickerView()
        let btnTitle = doneButtonText ?? "Done"

        pickerView?.dataSource = self
        pickerView?.delegate = self

        self.inputAccessoryView = {
            let frame = CGRect.init(x: 0, y: 0, width: parentViewController.view.frame.size.width, height: 44)
            let toolbar = UIToolbar(frame: frame)
            toolbar.setBackgroundImage(UIImage.imageWithColor(toolbarColor), forToolbarPosition: .bottom, barMetrics: .default)
            let done = UIBarButtonItem.init(title: btnTitle, style: UIBarButtonItem.Style.plain, target: self, action: #selector(UIResponder.resignFirstResponder))
            done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: toolbarButtonColor], for: UIControl.State())
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [spacer, done]
            return toolbar
        }()
    }

}

private extension UITextField {

    // MARK: - Variables
    struct AssociatedKey {
        static var parentViewController = "_UIViewController_._parentViewController"
        static var options = "_UIViewController_._options"
        static var pickerView = "_UIViewController_._pickerView"
    }

    /// The UIViewConroller used to show the UIPickerView itself
    private var parentViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.parentViewController) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.parentViewController, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The array of string used as options for the UIPickerView
    private var options: [String]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.options) as? [String]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.options, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.inputView = pickerView
        }
    }

    /// The UIPickerView itself...
    private var pickerView: UIPickerView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.pickerView) as? UIPickerView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.pickerView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.inputView = pickerView
        }
    }

    /// A UIToolbar needed to close the keyboard
    private var toolbar: UIToolbar {
        get { return UIToolbar() }
    }

}


// MARK: - UIPickerViewDataSource
extension UITextField: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return (options != nil ? 1 : 0)
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let options = options { return options.count }
        return 0
    }

}


// MARK: - UIPickerViewDelegate
extension UITextField: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options?[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = options?[row]
    }
}

// MARK: - UIImage∫
extension UIImage {
    /// Create a UIImage with a single color
    ///
    /// - Parameter color: the color for the image
    /// - Returns: the generated UIImage
    class func imageWithColor(_ color: UIColor) -> UIImage? {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(x: 0, y: 0, width: 1, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
