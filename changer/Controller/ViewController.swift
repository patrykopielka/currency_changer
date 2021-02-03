import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var FirstCurrencyPicker: UIPickerView!
    @IBOutlet weak var SecondCurrencyPicker: UIPickerView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var currencyManager = CurrencyManager()
    var FirstSelectedCurrency = ""
    var SecondSelectedCurrency = ""
    var value = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyManager.delegate = self
        valueTextField.delegate = self
        
        FirstCurrencyPicker.dataSource = self
        SecondCurrencyPicker.dataSource = self
        FirstCurrencyPicker.delegate = self
        SecondCurrencyPicker.delegate = self
        
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        valueTextField.endEditing(true)
        currencyManager.getChangedValue(firstCurrency: FirstSelectedCurrency, secondCurrency: SecondSelectedCurrency)
        
        value = 0.0
        errorLabel.text = ""
        
        let currentValue = valueTextField.text!
        
        if Int(currentValue) != nil {
            value = Double(currentValue)!
        } else {
            errorLabel.text = "You have to enter a number"
        }
    }
    
    
}

extension ViewController: CurrencyManagerDelegate {
    
    func didUpdateValue(rate: String, currency: String) {
        DispatchQueue.main.async {
            self.valueLabel.text = String(format: "%.2f" ,Double(rate)! * self.value )
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            FirstSelectedCurrency = currencyManager.currencyArray[row]
        }
        if pickerView.tag == 2 {
            SecondSelectedCurrency = currencyManager.currencyArray[row]
        }
    }
    
}

