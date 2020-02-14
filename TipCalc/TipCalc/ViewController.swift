import UIKit

// Implement UITextFieldDelegate to block users from
// entering anything that isn't a float in total bill
class ViewController: UIViewController, UITextFieldDelegate {
    // References to all components I want to either
    // receive values from our change values
    @IBOutlet weak var totalBillTextField: UITextField!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var tipSplitTextField: UITextField!
    @IBOutlet weak var totalSplitTextField: UITextField!
    
    // Returns a Double version of the string value
    // assigned to totalBillTextField
    var totalBill: Double? {
        return Double(totalBillTextField.text!)
    }
    
    // Stores the changing tip percentage
    var tipPercentage: Double = 0.15
    
    // Stores the changing number of people paying
    var numberOfPeople: Double = 1.0
    
    // Used to define we will only allow conforming
    // decimal numbers to be allowed for user input
    private var formatter: NumberFormatter!
    
    // Called when the app loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define if a tap gesture occurs on the main
        // view that the keyboard should be closed
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // Assign the textfields delegate to the view
        // controller class
        totalBillTextField.delegate = self
        
        // Initialize the formatter and define the number
        // must conform to the decimal format and have a
        // minimum value of zero
        formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.minimum = 0
    }

    @IBAction func tipSliderChanged(_ sender: UISlider) {
        // Get slider value
        let sliderValue = Int(sender.value)
        // Assign slider value to the label with a %
        tipPercentLabel.text = "\(sliderValue)%"
        // Change value for tip percentage
        tipPercentage = Double(Int(sender.value)) * 0.01
        updateInterface()
    }
    
    @IBAction func splitStepperChanged(_ sender: UIStepper) {
        // Get stepper value
        let stepperValue = Int(sender.value)
        // Assign stepper value to the label
        splitLabel.text = "\(stepperValue)"
        numberOfPeople = Double(stepperValue)
        updateInterface()
    }
    
    // Called when the total bill textfield loses focus
    @IBAction func totalBillTextFieldChanged(_ sender: UITextField) {
        updateInterface()
    }
    
    // When resignFirstResponder is called on the
    // textfield it closes the keyboard
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        totalBillTextField.resignFirstResponder()
    }
    
    func updateInterface(){
        // Get value in Total Bill and calculate tip amount
        if let totalBill = self.totalBill {
            tipTextField.text = String(format: "$%.2f", (totalBill * tipPercentage))
            totalTextField.text = String(format: "$%.2f", (totalBill * tipPercentage) + totalBill)
            tipSplitTextField.text = String(format: "$%.2f", (totalBill * tipPercentage) / numberOfPeople)
            totalSplitTextField.text = String(format: "$%.2f", ((totalBill * tipPercentage) + totalBill) / numberOfPeople)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // If the textfield value conforms to the formatter's
        // settings then it is valid and if not then nil is
        // returned and the value isn't allowed
        return formatter.number(from: "\(textField.text ?? "0.00")\(string)") != nil
    }
}

