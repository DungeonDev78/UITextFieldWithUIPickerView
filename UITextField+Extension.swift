//
//  UITextField+Extension.swift
//
//  Created with 💪 by Alessandro Manilii.
//  Copyright © 2019 Alessandro Manilii. All rights reserved.
//

import UIKit

// MARK: - UIPickerView
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

// MARK: - DatePickerConfigurator

// ******************************************************************
// If you need to create new formatters http://nsdateformatter.com
// ******************************************************************

/// Wrapper class to configure the picker in the UITextField
class DatePickerConfigurator {
    
    var formatter: String
    var locale: String
    var maximumDate: Date?
    var minimumDate: Date?
    var pickerMode: UIDatePicker.Mode
    
    /// Initialize the DatePickerConfigurator with all the needed  parameters
    ///
    /// - Parameters:
    ///   - pickerMode: the mode of the picker (date, time, etc...)
    ///   - formatter: the formatter for the output string
    ///   - locale: the locale used to show the date output string
    ///   - maximumDate: maximum date available on the picker
    ///   - minimumDate: minimum date available on the picker
    init(pickerMode: UIDatePicker.Mode = .date, formatter: String = "dd MMM yyyy", locale: String = "en", maximumDate: Date? = nil, minimumDate: Date? = nil ) {
        self.formatter = formatter
        self.locale = locale
        self.maximumDate = maximumDate
        self.minimumDate = minimumDate
        self.pickerMode = pickerMode
    }

}

// MARK: - UIDatePicker
extension UITextField {
    
    /// Configure the chosen UITextField in order to use a selectable UIDatePicker. The picker has an input accessory view with a toolbar used to close the keyboard
    ///
    /// - Parameters:
    ///   - datePickerConfigurator: the DatePickerConfigurator object needed to configure the picker
    ///   - parentViewController: the UIViewController chosen to show the picker, the one holding the UITextField
    ///   - doneButtonText: the text used in the "Done" button
    func configureWith(_ datePickerConfigurator: DatePickerConfigurator,
                       on parentViewController: UIViewController,
                       doneButtonText: String? = nil,
                       toolbarColor: UIColor = .lightGray,
                       toolbarButtonColor: UIColor = .black) {
        
        self.parentViewController = parentViewController
        self.datePickerConfigurator = datePickerConfigurator
        self.datePicker = UIDatePicker()
        let btnTitle = doneButtonText ?? "Done"
        
        datePicker?.datePickerMode = datePickerConfigurator.pickerMode
        datePicker?.minimumDate = datePickerConfigurator.minimumDate
        datePicker?.maximumDate = datePickerConfigurator.maximumDate
        
        datePicker?.addTarget(self, action: #selector(datePickerDidChangeValue), for: .valueChanged)
        
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
    
    /// Get the Optional(Date) object associated to the UIDatePiker of the UITextfield
    ///
    /// - Returns: the Optional(Date)
    func getPickerDate() -> Date? {
        return datePicker?.date
    }
}

// MARK:- Private Commons
private extension UITextField {
    
    // MARK: - Variables
    struct AssociatedKey {
        static var parentViewController = "_UIViewController_._parentViewController"
        static var options = "_UIViewController_._options"
        static var pickerView = "_UIViewController_._pickerView"
        static var datePicker = "_UIViewController_._datePicker"
        static var datePickerConfigurator = "_UIViewController_._datePickerConfigurator"
    }
    
    /// A UIToolbar needed to close the keyboard
    private var toolbar: UIToolbar {
        get { return UIToolbar() }
    }
}

// MARK:- Private UIDatePicker
private extension UITextField {

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
}

// MARK:- Private UIDatePicker
private extension UITextField {
    
    /// The UIDatePicker itself...
    private var datePicker: UIDatePicker? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.datePicker) as? UIDatePicker
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.datePicker, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.inputView = datePicker
        }
    }
    
    /// The UIDatePicker itself...
    private var datePickerConfigurator: DatePickerConfigurator? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.datePickerConfigurator) as? DatePickerConfigurator
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.datePickerConfigurator, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Observe the change in the UIDatePicker selector
    ///
    /// - Parameter datePicker: the observed UIDatePicker
    @objc func datePickerDidChangeValue(_ datePicker: UIDatePicker) {
        self.text = getFormattedDate()
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func getFormattedDate() -> String {
        guard let gSelectedDate = datePicker?.date, let gConfigurator = datePickerConfigurator else { return datePicker?.date.description ?? "*** ERROR ***" }
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: gConfigurator.locale)
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = gConfigurator.formatter

        return formatter.string(from: gSelectedDate)
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

// MARK: - UIImage
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
