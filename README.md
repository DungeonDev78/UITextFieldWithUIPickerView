# UITextField+Extension - UIPikerViews

A UITextField extension in Swift 5.0 with a prebuilt UIPickerView in the place of a normal keyboard. Choose one of the presented options and the UITextFiled will update automatically it's string value.

## Installation

Copy the Swift extension included in the repo in your project.


## Usage


## UIPickerView
Use the next simple command on the chosen UITextField and add the array of String as options. Select the UIViewController that holds the UITextField. Chose an optional text for the **Done** button.

```
myTxtField.configureWith(options: ["First", "Second", "Third"], 
                         on: self, 
                         doneButtonText: "CLOSE",
                         toolbarColor: .red, 
                         toolbarButtonColor: .white)
```

Or super short:

```
myTxtField.configureWith(options: ["First", "Second", "Third"], on: self)
```

## UIDatePicker

Use the next simple command on the chosen UITextField to add a UIDatePicker as selection options. 

First create the DatePickerConfigurator object:
```
 let dateConfigurator = DatePickerConfigurator(pickerMode: .date,
                                                      formatter:  "dd MMM yyyy",
                                                      locale: "it_IT", maximumDate: myFutureDate,
                                                      minimumDate: myPastDate)
```


Select the UIViewController that holds the UITextField. Chose an optional text for the **Done** button.
```
myTxtField.configureWith(dateConfigurator, on: self, doneButtonText: "Done", toolbarColor: .red, toolbarButtonColor: .white)
```
Or super short:

```
myTxtField.configureWith(dateConfigurator, on: self)
```

If you need to access to the UIDatePicker Date object, just use:
```
myTxtField.getPickerDate()
```


## Author

* **Alessandro "DungeonDev78" Manilii**

## License

This project is licensed under the MIT License
