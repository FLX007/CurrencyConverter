//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by FR on 28.11.2021.
//

import UIKit

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
        // Do any additional setup after loading the view.
    }


}

