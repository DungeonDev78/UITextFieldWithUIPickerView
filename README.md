# UITextField+Extension - UIPikerView

A UITextField extension with a prebuilt UIPickerView in the place of a normal keyboard. Choose one of the presented options and the UITextFiled will update automatically it's string value.

## Installation

Copy the Swift extension included in the repo in your project.


## Usage

Use the next simple command on the chosen UITextField and add the array of String as options. Select the UIViewController that holds the UITextField. Chose an optional text for the **Done** button.

```
myTxtFiled.configureWith(options: ["First", "Second", "Third"], 
                         on: self, 
                         doneButtonText: "CLOSE")
```

## Author

* **Alessandro "DungeonDev78" Manilii**

## License

This project is licensed under the MIT License
