//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by FR on 28.11.2021.
//

import UIKit
import Alamofire

enum Direction {
    case srcToDest
    case destToSrc
}

class MainViewController: UIViewController {
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var sourceAmountTextField: UITextField!
    @IBOutlet weak var destAmountTextField: UITextField!
    @IBOutlet weak var destAmountLabel: UILabel!
    
    private var currencies: [String] = []
    private var exchange: Exchange!
    private var lastDirection: Direction = .srcToDest
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        getCurrencies()
        hideKeyboardWhenTappedAround()
    }
    private func updateDestAmountLabel(_ row: Int) {
        destAmountLabel.text = "\(currencies[row]) amount:"
    }
    
    private func getCurrencies() {
        NetworkManager.shared.fetchExchange() { exchange in
            self.exchange = exchange
            self.currencies = self.gerCurrencies()
            DispatchQueue.main.async {
                self.currencyPicker.reloadAllComponents()
                self.updateDestAmountLabel(0)
            }
        }
    }
    
    private func updateAmounts(_ direction: Direction) {
        let fromTextField: UITextField!
        let toTextField: UITextField!
        let rate = getRate(currencies[currencyPicker.selectedRow(inComponent: 0)])
        
        if direction == .srcToDest {
            fromTextField = sourceAmountTextField
            toTextField = destAmountTextField
        } else {
            fromTextField = destAmountTextField
            toTextField = sourceAmountTextField
        }

        guard let text = fromTextField.text else { return }
        if let currentValue = Double(text) {
            toTextField.text = String(format: "%.2f", direction == .srcToDest ? currentValue * rate : currentValue / rate)
        }
    }
    
    func gerCurrencies() -> [String] {
        Mirror(reflecting: exchange.rates).children.map {$0.label ?? ""}
    }
    
    func getRate(_ currency: String) -> Double {
        guard let value = Mirror(reflecting: exchange.rates).children.filter({$0.label == currency})[0].value as? Double else {
            return 0
        }
        return value
    }
    @IBAction func sourceAmountEditingChanged() {
        updateAmounts(.srcToDest)
        lastDirection = .srcToDest
    }
    @IBAction func destAmountEditingChanged() {
        updateAmounts(.destToSrc)
        lastDirection = .destToSrc
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateDestAmountLabel(row)
        updateAmounts(lastDirection)
    }
}

extension MainViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

